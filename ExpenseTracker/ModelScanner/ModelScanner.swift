//
//  ModelScanner.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 04/11/26.
//

import SwiftUI
import VisionKit

struct ModelScanner: View {

    @State private var serialNumber: String?
    @State private var modelNumber: String?

    var body: some View {
        ZStack {

            // MARK: Camera

            if DataScannerViewController.isSupported &&
               DataScannerViewController.isAvailable {

                ScannerView(
                    serialNumber: $serialNumber,
                    modelNumber: $modelNumber
                )
                .ignoresSafeArea()

            } else {

                Color.black
                    .ignoresSafeArea()

                VStack(spacing: 12) {
                    Image(systemName: "camera.slash")
                        .font(.system(size: 50))
                        .foregroundStyle(.white)

                    Text("Camera scanning is not available")
                        .foregroundStyle(.white)
                }
            }

            // MARK: Overlay

            VStack {

                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {

                        Text("MacBook Reader")
                            .font(.title2.bold())
                            .foregroundStyle(.white)

                        Text("Point the camera anywhere at the MacBook")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.8))
                    }

                    Spacer()

                    Image(systemName: "camera.viewfinder")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
                .padding()
                .background(.black.opacity(0.35))

                Spacer()

                // Scanning status
                HStack(spacing: 8) {

                    Circle()
                        .fill(
                            serialNumber != nil
                            ? .green
                            : .yellow
                        )
                        .frame(width: 8, height: 8)

                    Text(
                        serialNumber == nil
                        ? "Scanning..."
                        : "MacBook detected"
                    )
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white)

                }
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background(.black.opacity(0.7))
                .clipShape(Capsule())

                // Result
                if serialNumber != nil || modelNumber != nil {

                    VStack(alignment: .leading, spacing: 16) {

                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)

                            Text("MacBook Found")
                                .font(.headline)

                            Spacer()
                        }

                        if let serialNumber {
                            resultRow(
                                title: "Serial Number",
                                value: serialNumber
                            )
                        }

                        if let modelNumber {
                            resultRow(
                                title: "Model Number",
                                value: modelNumber
                            )
                        }

                    }
                    .padding()
                    .background(.regularMaterial)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20)
                    )
                    .padding()
                    .transition(.move(edge: .bottom))
                }
            }
        }
        .animation(
            .easeInOut,
            value: serialNumber
        )
    }

    // MARK: Result Row

    private func resultRow(
        title: String,
        value: String
    ) -> some View {

        VStack(alignment: .leading, spacing: 5) {

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.title3.monospaced().bold())
                .foregroundStyle(.primary)
        }
    }
}


// MARK: - Scanner

struct ScannerView: UIViewControllerRepresentable {

    @Binding var serialNumber: String?
    @Binding var modelNumber: String?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(
        context: Context
    ) -> DataScannerViewController {

        let scanner = DataScannerViewController(

            recognizedDataTypes: [
                .text()
            ],

            qualityLevel: .balanced,

            recognizesMultipleItems: true,

            isHighFrameRateTrackingEnabled: true,

            isPinchToZoomEnabled: true,

            isGuidanceEnabled: false,

            isHighlightingEnabled: true
        )

        scanner.delegate = context.coordinator

        try? scanner.startScanning()

        return scanner
    }

    func updateUIViewController(
        _ uiViewController: DataScannerViewController,
        context: Context
    ) {
        // Nothing required here.
    }

    // MARK: Coordinator

    final class Coordinator:
        NSObject,
        DataScannerViewControllerDelegate {

        private let parent: ScannerView

        init(_ parent: ScannerView) {
            self.parent = parent
        }

        // Called when new text is detected
        func dataScanner(
            _ dataScanner: DataScannerViewController,
            didAdd addedItems: [RecognizedItem],
            allItems: [RecognizedItem]
        ) {

            process(allItems)
        }

        // Called when detected text changes
        func dataScanner(
            _ dataScanner: DataScannerViewController,
            didUpdate updatedItems: [RecognizedItem],
            allItems: [RecognizedItem]
        ) {

            process(allItems)
        }

        // MARK: Process OCR

        private func process(
            _ items: [RecognizedItem]
        ) {

            for item in items {

                guard case .text(let text) = item else {
                    continue
                }

                let value = text.transcript
                    .trimmingCharacters(
                        in: .whitespacesAndNewlines
                    )

                let normalized = value
                    .uppercased()
                    .replacingOccurrences(
                        of: " ",
                        with: ""
                    )

                print("Detected:", normalized)

                // --------------------------------
                // MacBook Model Number
                // Example: A2442
                // --------------------------------

                if isModelNumber(normalized) {

                    DispatchQueue.main.async {

                        if self.parent.modelNumber == nil {
                            self.parent.modelNumber = normalized
                        }
                    }

                    continue
                }

                // --------------------------------
                // Potential Serial Number
                // --------------------------------

                if isPotentialSerial(normalized) {

                    DispatchQueue.main.async {

                        if self.parent.serialNumber == nil {
                            self.parent.serialNumber = normalized
                        }
                    }
                }
            }
        }

        // MARK: Model Validation

        private func isModelNumber(
            _ value: String
        ) -> Bool {

            let pattern = #"^A\d{4}$"#

            return value.range(
                of: pattern,
                options: .regularExpression
            ) != nil
        }

        // MARK: Serial Validation

        private func isPotentialSerial(
            _ value: String
        ) -> Bool {

            // Apple serial numbers can vary,
            // so don't make this too restrictive.

            guard value.count >= 8,
                  value.count <= 14 else {
                return false
            }

            let allowed =
                CharacterSet.alphanumerics

            return value.unicodeScalars.allSatisfy {
                allowed.contains($0)
            }
        }
    }
}


// MARK: - Preview

//#Preview {
//    ContentView()
//}
