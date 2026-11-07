// MacBookReaderApp.swift
// iPhone app: set a MacBook down, model + serial (+ EMC) on screen in ~3 s.
// On-device only (AVFoundation + Vision + CoreImage). No network.
//
// SETUP
// 1. Xcode > New Project > iOS App (SwiftUI). Delete the generated App/ContentView files.
// 2. Add this file. Deployment target iOS 17+ (spec says iOS 26 / iPhone 16 Pro+).
// 3. Info tab: add "Privacy - Camera Usage Description" (NSCameraUsageDescription).
// 4. Build Settings: Swift Language Version = Swift 5 (avoids strict-concurrency errors).
// 5. Optional: Info.plist "UIFileSharingEnabled" = YES to pull the CSV via Files/Finder.

import SwiftUI
import AVFoundation
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins
import AudioToolbox
import Combine


// MARK: - Models

struct Reading {
    var model: String?
    var serial: String?
    var emc: String?
}

enum ScanState { case idle, scanning, confirmed, review }

// MARK: - Parsing

enum Parser {
    static func parse(_ lines: [String]) -> Reading {
        let text = lines.joined(separator: " ").uppercased()
        var r = Reading()

        if let m = match(#"MODEL\s*:?\s*A\s*([0-9OISB]{4})"#, text) ?? match(#"\bA([0-9OISB]{4})\b"#, text) {
            r.model = "A" + fixDigits(m)
        }
        if let s = match(#"SERIAL\s*(?:NO\.?|NUMBER|#)?\s*:?\s*([A-Z0-9]{10,12})\b"#, text) {
            r.serial = s
        } else {
            // Fallback: standalone 10/12-char token with at least one digit and one letter.
            for tok in text.split(whereSeparator: { !$0.isLetter && !$0.isNumber }) {
                let t = String(tok)
                if (t.count == 10 || t.count == 12),
                   t.contains(where: \.isNumber), t.contains(where: \.isLetter),
                   !t.hasPrefix("MODEL") {
                    r.serial = t; break
                }
            }
        }
        if let e = match(#"EMC\s*:?\s*([0-9OISB]{4})"#, text) {
            r.emc = fixDigits(e)
        }
        return r
    }

    private static func fixDigits(_ s: String) -> String {
        String(s.map { c -> Character in
            switch c { case "O": return "0"; case "I": return "1"; case "S": return "5"; case "B": return "8"; default: return c }
        })
    }

    private static func match(_ pattern: String, _ text: String) -> String? {
        guard let re = try? NSRegularExpression(pattern: pattern),
              let m = re.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)),
              m.numberOfRanges > 1, let r = Range(m.range(at: 1), in: text) else { return nil }
        return String(text[r])
    }
}

// MARK: - Recognizer (Vision, multi-variant, multi-orientation)

final class Recognizer: @unchecked Sendable {
    enum Variant: CaseIterable { case original, enhanced, enhancedInverted }

    private let ciContext = CIContext(options: [.useSoftwareRenderer: false])
    private var rotation = 0
    private var lastGood: (Variant, CGImagePropertyOrientation)?
    private let orientations: [CGImagePropertyOrientation] = [.right, .left, .up, .down]

    private var combos: [(Variant, CGImagePropertyOrientation)] {
        Variant.allCases.flatMap { v in orientations.map { (v, $0) } }
    }

    /// Returns recognized text lines (merged across the attempts made for this frame).
    func process(_ pixelBuffer: CVPixelBuffer) -> [String] {
        var attempts: [(Variant, CGImagePropertyOrientation)] = []
        if let g = lastGood { attempts.append(g) }
        let all = combos
        for _ in 0..<2 {
            attempts.append(all[rotation % all.count]); rotation += 1
        }

        let base = CIImage(cvPixelBuffer: pixelBuffer)
        var lines: [String] = []
        for (variant, orientation) in attempts {
            let result = recognize(base: base, buffer: pixelBuffer, variant: variant, orientation: orientation)
            if !result.isEmpty {
                lines += result
                let p = Parser.parse(result)
                if p.model != nil || p.serial != nil { lastGood = (variant, orientation) }
            }
        }
        return lines
    }

    private func recognize(base: CIImage, buffer: CVPixelBuffer, variant: Variant, orientation: CGImagePropertyOrientation) -> [String] {
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = false
        request.minimumTextHeight = 0.008
        request.recognitionLanguages = ["en-US"]

        let handler: VNImageRequestHandler
        switch variant {
        case .original:
            handler = VNImageRequestHandler(cvPixelBuffer: buffer, orientation: orientation)
        case .enhanced, .enhancedInverted:
            guard let cg = ciContext.createCGImage(enhance(base, invert: variant == .enhancedInverted), from: base.extent) else { return [] }
            handler = VNImageRequestHandler(cgImage: cg, orientation: orientation)
        }
        try? handler.perform([request])
        return (request.results ?? []).compactMap { $0.topCandidates(1).first?.string }
    }

    /// Lifts shadows and boosts local contrast: helps tone-on-tone engraving on dark cases.
    private func enhance(_ image: CIImage, invert: Bool) -> CIImage {
        let gamma = CIFilter.gammaAdjust(); gamma.inputImage = image; gamma.power = 0.55
        let controls = CIFilter.colorControls()
        controls.inputImage = gamma.outputImage; controls.saturation = 0; controls.contrast = 2.2; controls.brightness = 0.0
        let sharp = CIFilter.unsharpMask()
        sharp.inputImage = controls.outputImage; sharp.radius = 4; sharp.intensity = 1.5
        var out = sharp.outputImage ?? image
        if invert {
            let inv = CIFilter.colorInvert(); inv.inputImage = out; out = inv.outputImage ?? out
        }
        return out
    }
}

// MARK: - Camera

final class CameraController: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, @unchecked Sendable {
    let session = AVCaptureSession()
    private let output = AVCaptureVideoDataOutput()
    private let queue = DispatchQueue(label: "camera.frames")
    private let recognizer = Recognizer()
    private var device: AVCaptureDevice?
    private var busy = false
    private var lastRun = Date.distantPast

    /// Called on main with merged text lines for each processed frame.
    var onLines: (([String]) -> Void)?

    func start() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] ok in
            guard ok, let self else { return }
            self.queue.async { self.configure(); self.session.startRunning() }
        }
    }

    func stop() { queue.async { self.session.stopRunning() } }

    private func configure() {
        guard device == nil else { return }
        session.beginConfiguration()
        session.sessionPreset = session.canSetSessionPreset(.hd4K3840x2160) ? .hd4K3840x2160 : .hd1920x1080

        let discovery = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInTripleCamera, .builtInDualWideCamera, .builtInWideAngleCamera],
            mediaType: .video, position: .back)
        guard let dev = discovery.devices.first, let input = try? AVCaptureDeviceInput(device: dev),
              session.canAddInput(input) else { session.commitConfiguration(); return }
        session.addInput(input)
        device = dev

        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        output.alwaysDiscardsLateVideoFrames = true
        output.setSampleBufferDelegate(self, queue: queue)
        if session.canAddOutput(output) { session.addOutput(output) }
        session.commitConfiguration()

        try? dev.lockForConfiguration()
        if dev.isFocusModeSupported(.continuousAutoFocus) { dev.focusMode = .continuousAutoFocus }
        if dev.isAutoFocusRangeRestrictionSupported { dev.autoFocusRangeRestriction = .near }
        if dev.isExposureModeSupported(.continuousAutoExposure) { dev.exposureMode = .continuousAutoExposure }
        dev.unlockForConfiguration()
    }

    func setTorch(_ on: Bool) {
        guard let d = device, d.hasTorch else { return }
        try? d.lockForConfiguration()
        d.torchMode = on ? .on : .off
        d.unlockForConfiguration()
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard !busy, Date().timeIntervalSince(lastRun) > 0.12,
              let pb = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        busy = true; lastRun = Date()
        let lines = recognizer.process(pb)
        busy = false
        DispatchQueue.main.async { self.onLines?(lines) }
    }
}

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession
    func makeUIView(context: Context) -> PreviewView {
        let v = PreviewView(); v.previewLayer.session = session; v.previewLayer.videoGravity = .resizeAspectFill; return v
    }
    func updateUIView(_ uiView: PreviewView, context: Context) {}
    final class PreviewView: UIView {
        override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
        var previewLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }
    }
}

// MARK: - CSV log

final class CSVLog {
    let url: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("macbook_log.csv")
    private(set) var serials = Set<String>()

    init() {
        if let text = try? String(contentsOf: url, encoding: .utf8) {
            for row in text.split(separator: "\n").dropFirst() {
                let cols = row.split(separator: ",", omittingEmptySubsequences: false)
                if cols.count > 2, !cols[2].isEmpty { serials.insert(String(cols[2])) }
            }
        } else {
            try? "timestamp,model,serial,emc,status,ms,repeat\n".write(to: url, atomically: true, encoding: .utf8)
        }
    }

    /// Returns true if the serial was already logged (repeat).
    @discardableResult
    func append(model: String, serial: String, emc: String, status: String, ms: Int) -> Bool {
        let isRepeat = !serial.isEmpty && serials.contains(serial)
        if !serial.isEmpty { serials.insert(serial) }
        let row = "\(ISO8601DateFormatter().string(from: Date())),\(model),\(serial),\(emc),\(status),\(ms),\(isRepeat ? "REPEAT" : "")\n"
        if let h = try? FileHandle(forWritingTo: url), let data = row.data(using: .utf8) {
            h.seekToEndOfFile(); h.write(data); try? h.close()
        }
        return isRepeat
    }
}

// MARK: - View model (voting + state machine)

@MainActor
final class ReaderModel: ObservableObject {
    @Published var state: ScanState = .idle
    @Published var model = "—"
    @Published var serial = "—"
    @Published var emc = ""
    @Published var message = "Set a MacBook down, bottom up"
    @Published var elapsedMs = 0
    @Published var scanCount = 0
    @Published var isRepeat = false

    let camera = CameraController()
    private let log = CSVLog()
    var logURL: URL { log.url }

    private var votes: [String: [String: Int]] = ["model": [:], "serial": [:], "emc": [:]]
    private var startTime: Date?
    private var emptyFrames = 0
    private var logged = false
    private let timeLimit = 3.0
    private let requiredAgreement = 2

    func start() {
        UIApplication.shared.isIdleTimerDisabled = true
        camera.onLines = { [weak self] lines in self?.handle(lines) }
        camera.start()
        reset()
    }

    private func reset() {
        votes = ["model": [:], "serial": [:], "emc": [:]]
        startTime = nil; emptyFrames = 0; logged = false; isRepeat = false
        state = .idle; model = "—"; serial = "—"; emc = ""; elapsedMs = 0
        message = "Set a MacBook down, bottom up"
    }

    private func best(_ key: String) -> (value: String, count: Int)? {
        votes[key]?.max(by: { $0.value < $1.value }).map { ($0.key, $0.value) }
    }

    private func handle(_ lines: [String]) {
        let hasText = !lines.isEmpty
        if !hasText {
            emptyFrames += 1
            // Lifted: finalize any unconfirmed read, then get ready for the next one.
            if emptyFrames >= 8, state != .idle {
                if state == .review && !logged { writeLog(status: "REVIEW") }
                reset()
            }
            return
        }
        emptyFrames = 0

        if state == .idle { state = .scanning; startTime = Date(); message = "Reading…" }
        if state == .confirmed { return }

        let r = Parser.parse(lines)
        if let m = r.model { votes["model"]![m, default: 0] += 1 }
        if let s = r.serial { votes["serial"]![s, default: 0] += 1 }
        if let e = r.emc { votes["emc"]![e, default: 0] += 1 }

        let m = best("model"), s = best("serial"), e = best("emc")
        elapsedMs = Int(Date().timeIntervalSince(startTime ?? Date()) * 1000)
        model = m?.value ?? "—"; serial = s?.value ?? "—"; emc = e.map { "EMC \($0.value)" } ?? ""

        let modelOK = (m?.count ?? 0) >= requiredAgreement
        let serialOK = (s?.count ?? 0) >= requiredAgreement

        if modelOK && serialOK {
            state = .confirmed; message = "Read OK"
            writeLog(status: "OK")
            feedback(success: true)
        } else if Date().timeIntervalSince(startTime ?? Date()) > timeLimit, state == .scanning {
            state = .review; message = "Review: not sure, do not trust"
            feedback(success: false)
        }
    }

    private func writeLog(status: String) {
        guard !logged else { return }
        logged = true
        isRepeat = log.append(model: model == "—" ? "" : model,
                              serial: serial == "—" ? "" : serial,
                              emc: emc.replacingOccurrences(of: "EMC ", with: ""),
                              status: status, ms: elapsedMs)
        scanCount += 1
        if isRepeat { message = "REPEAT SERIAL" }
    }

    private func feedback(success: Bool) {
        AudioServicesPlaySystemSound(success ? 1057 : 1053)
        UINotificationFeedbackGenerator().notificationOccurred(success ? .success : .warning)
    }
}

// MARK: - UI

struct ScannerView: View {
    @StateObject private var vm = ReaderModel()
    @State private var torch = false

    private var color: Color {
        if vm.isRepeat { return .orange }
        switch vm.state {
        case .confirmed: return .green
        case .review: return .yellow
        case .scanning: return .blue
        case .idle: return .gray
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                CameraPreview(session: vm.camera.session)
                    .frame(height: 260).clipped()
                Button {
                    torch.toggle(); vm.camera.setTorch(torch)
                } label: {
                    Image(systemName: torch ? "flashlight.on.fill" : "flashlight.off.fill")
                        .padding(12).background(.ultraThinMaterial, in: Circle())
                }.padding(10)
            }

            VStack(spacing: 14) {
                Text(vm.message).font(.title3.bold()).foregroundStyle(color)
                    .multilineTextAlignment(.center)
                VStack(spacing: 4) {
                    Text("MODEL").font(.caption).foregroundStyle(.secondary)
                    Text(vm.model).font(.system(size: 56, weight: .heavy, design: .monospaced))
                        .minimumScaleFactor(0.5)
                }
                VStack(spacing: 4) {
                    Text("SERIAL").font(.caption).foregroundStyle(.secondary)
                    Text(vm.serial).font(.system(size: 40, weight: .bold, design: .monospaced))
                        .minimumScaleFactor(0.4).lineLimit(1)
                }
                if !vm.emc.isEmpty { Text(vm.emc).font(.title2.monospaced()) }
                Text("\(vm.elapsedMs) ms").font(.caption.monospacedDigit()).foregroundStyle(.secondary)
                Spacer()
                HStack {
                    Text("Scanned: \(vm.scanCount)").font(.headline)
                    Spacer()
                    ShareLink(item: vm.logURL) { Label("Export CSV", systemImage: "square.and.arrow.up") }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(color.opacity(0.15))
        }
        .ignoresSafeArea(edges: .top)
        .onAppear { vm.start() }
        .onDisappear { vm.camera.stop() }
    }
}
