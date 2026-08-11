//
//  ResumableDownloadView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 11/08/26.
//

import SwiftUI
import Combine
import QuickLook

struct DownloadRing: View {

    let progress: Double

    var body: some View {
        ZStack {

            // Background ring
            Circle()
                .stroke(
                    .gray.opacity(0.2),
                    lineWidth: 6
                )

            // Progress ring
            Circle()
                .trim(
                    from: 0,
                    to: progress
                )
                .stroke(
                    .blue,
                    style: StrokeStyle(
                        lineWidth: 6,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))

            // Percentage
            Text("\(Int(progress * 100))%")
                .font(.caption)
                .fontWeight(.semibold)
        }
        .frame(width: 60, height: 60)
        .animation(
            .linear(duration: 0.1),
            value: progress
        )
    }
}

struct ResumableDownloadView: View {
    
    
    @StateObject var downloader: ResumableDownloader = ResumableDownloader()
    @State var showPdf: Bool = false
    
    var body: some View {
        if downloader.path != "", let url = URL(string: downloader.path) {
            Text(url.lastPathComponent).onTapGesture {
                showPdf = true
            }
            .sheet(isPresented: $showPdf) {
                PDFPreview(url: url)
            }
        } else {
            HStack {
                if downloader.isDownloading {
                    DownloadRing(progress: downloader.progress)
                        .progressViewStyle(.circular).scaleEffect(2)
                    Text("Downloading")
                } else if downloader.isPaused {
                    DownloadRing(progress: downloader.progress)
                        .progressViewStyle(.circular).scaleEffect(2)
                    Text("Resume")
                } else {
                    Text("Download")
                }
                
            }.onTapGesture {
                downloader.checkAndDownload()
                
            }
        }
            
    }
}



final class ResumableDownloader: NSObject, ObservableObject {
    @Published var path: String = ""
    
     lazy var session: URLSession = {
         URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }()
    
    @Published var isDownloading: Bool = false
    
    @Published var isPaused: Bool = false
    
    @Published var progress: Double = 0
    
    private var downloadTask: URLSessionDownloadTask?
    
    private var resumeData: Data?
    
    func checkAndDownload() {
        if isDownloading {
            pause()
        } else if isPaused {
            resume()
        } else {
            dowload()
        }
    }
    
    func dowload() {
        if let url = URL(string: "https://huggingface.co/dlptest02/dlp_testing/resolve/main/49mb.pdf") {
            let urlRequest = URLRequest(url: url)
            downloadTask = session.downloadTask(with: urlRequest)
            isDownloading = true
            downloadTask?.resume()
        }
    }
    
    func pause() {
        downloadTask?.cancel { [weak self] data in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                print("Resume data:", data?.count ?? 0)
                self.resumeData = data
                self.isPaused = true
                self.isDownloading = false
            }
        }
    }
    
    func resume() {
        if let resumeData = resumeData {
            downloadTask = session.downloadTask(withResumeData: resumeData)
            isDownloading = true
            isPaused = false
            downloadTask?.resume()
        }
    }
}
extension ResumableDownloader: URLSessionDownloadDelegate, URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: (any Error)?) {
        if let error  {
            let nsError = error as NSError

                    if nsError.code == NSURLErrorCancelled {
                        print("Download cancelled/paused")
                        return
                    }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                isDownloading = false
                isPaused = false
            }
        } else {
            print("download compltetd")
        }
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let response = downloadTask.response as? HTTPURLResponse {
                print("Status:", response.statusCode)
                print("Headers:", response.allHeaderFields)
                print("MIME:", response.mimeType)
                print("Expected:", response.expectedContentLength)
            }
        let fileManager = FileManager.default
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            isDownloading = false
            isPaused = false
        }
        do {
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let destination = documentsURL.appendingPathComponent("Sample.pdf")
            if fileManager.fileExists(atPath: destination.path) {
                try fileManager.removeItem(at: destination)
            }
            try fileManager.moveItem(at: location, to: destination)
            print("file saved yay at : \(destination)")
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                path = destination.absoluteString
            }
            
        } catch {
            print(error)
        }
        
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("totalBytesExpectedToWrite : \(totalBytesExpectedToWrite) - totalBytesWritten : \(totalBytesWritten)")
        let downloadedMB =
                Double(totalBytesWritten) / (1024 * 1024)

            let expectedMB =
                Double(totalBytesExpectedToWrite) / (1024 * 1024)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            progress = downloadedMB / expectedMB
        }
            print(
                String(
                    format: "%.2f MB / %.2f MB",
                    downloadedMB,
                    expectedMB
                )
            )
        
    }
}



struct PDFPreview: UIViewControllerRepresentable {

    let url: URL

    func makeUIViewController(
        context: Context
    ) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        return controller
    }

    func updateUIViewController(
        _ controller: QLPreviewController,
        context: Context
    ) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(url: url)
    }

    final class Coordinator: NSObject, QLPreviewControllerDataSource {

        let url: URL

        init(url: URL) {
            self.url = url
        }

        func numberOfPreviewItems(
            in controller: QLPreviewController
        ) -> Int {
            1
        }

        func previewController(
            _ controller: QLPreviewController,
            previewItemAt index: Int
        ) -> QLPreviewItem {
            url as NSURL
        }
    }
}
#Preview {
    ResumableDownloadView()
}
