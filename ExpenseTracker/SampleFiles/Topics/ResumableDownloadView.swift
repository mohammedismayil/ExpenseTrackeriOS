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
                .fontWeight(.semibold).contentTransition(.numericText())
        }
        .frame(width: 30, height: 30)
        .animation(
            .linear(duration: 0.1),
            value: progress
        )
    }
}

struct ResumableDownloadView: View {
    
    
    @StateObject var downloader: ResumableDownloader = ResumableDownloader.shared
    @State var showPdf: Bool = false
    
    var body: some View {
        List(downloader.downloadItems) { item in
            if item.path != "", let path = item.path, let url = URL(string: path) {
                Text(url.lastPathComponent).onTapGesture {
                    showPdf = true
                }
                .sheet(isPresented: $showPdf) {
                    PDFPreview(url: url)
                }
            } else {
                HStack {
                    switch item.state {
                    case .idle:
                        Text("Download")
                    case .downloading:
                        DownloadRing(progress: item.progress ?? 0)
                            .progressViewStyle(.circular).scaleEffect(2)
                        Text("Downloading")
                    case .paused:
                        DownloadRing(progress: item.progress ?? 0)
                            .progressViewStyle(.circular).scaleEffect(2)
                        Text("Resume")
                    case .completed:
                        EmptyView()
                    case .failed:
                        DownloadRing(progress: item.progress ?? 0)
                            .progressViewStyle(.circular).scaleEffect(2)
                        Text("Retry")
                    }
                    
                }
                .onTapGesture {
                    downloader.startDownload(item: item)
                    
                }
            }
        }.onAppear {
            downloader.fetchDowloads()
        }
            
    }
}

enum DownloadState {
    case idle
    case downloading
    case paused
    case completed
    case failed
}

final class ResumableDownloader: NSObject, ObservableObject {
    @Published var path: String = ""
    
    static let shared = ResumableDownloader()
    
     lazy var session: URLSession = {
         let configuration = URLSessionConfiguration.background(withIdentifier: "ResumableDownloader")
         configuration.sessionSendsLaunchEvents = true
         configuration.isDiscretionary = false
         return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    @Published var downloadItems: [ResumableDownloadItem] = []
    
    @Published var tasks: [Int: URLSessionDownloadTask] = [:]
    
    @Published var downloadState: DownloadState = .idle
    
    @Published var progress: Double = 0
    
    private var downloadTask: URLSessionDownloadTask?
    
    private var resumeData: Data?
    
    var backgroundCompletionHandler: (() -> ())?
    
    func checkAndDownload() {
        switch downloadState {
        case .idle:
            dowload()
        case .downloading:
            pause()
        case .paused:
            resume()
        case .completed:
            break
        case .failed:
            resume()
        }
    }
    
    func dowload() {
        if let url = URL(string: "https://huggingface.co/dlptest02/dlp_testing/resolve/main/49mb.pdf") {
            let urlRequest = URLRequest(url: url)
            downloadTask = session.downloadTask(with: urlRequest)
            downloadState = .downloading
            downloadTask?.resume()
        }
    }
    
    func pause() {
        downloadTask?.cancel { [weak self] data in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                print("Resume data:", data?.count ?? 0)
                self.resumeData = data
                downloadState = .paused
            }
        }
    }
    
    func resume() {
        if let resumeData = resumeData {
            downloadTask = session.downloadTask(withResumeData: resumeData)
            downloadState = .downloading
            downloadTask?.resume()
        }
    }
    
    func fetchDowloads() {
        downloadItems = [ResumableDownloadItem(id: "1", taskId: 1, state: .idle),ResumableDownloadItem(id: "2", taskId: 2, state: .idle),ResumableDownloadItem(id: "3", taskId: 3, state: .idle),ResumableDownloadItem(id: "4", taskId: 4, state: .idle),ResumableDownloadItem(id: "5", taskId: 5, state: .idle)]
    }
    
    func startDownload(item: ResumableDownloadItem) {
        switch item.state {
        case .idle:
            downloadItem(item: item)
        case .downloading:
            pauseItem(item: item)
        case .paused:
            resumeItem(item: item)
        case .completed:
            break
        case .failed:
            resume()
        }
    }
    
    func downloadItem(item: ResumableDownloadItem) {
        if let url = URL(string: "https://huggingface.co/dlptest02/dlp_testing/resolve/main/49mb.pdf") {
            let urlRequest = URLRequest(url: url)
            let task = session.downloadTask(with: urlRequest)
            if let index = downloadItems.firstIndex(where: {$0.id == item.id}) {
                downloadItems[index].taskId = task.taskIdentifier
                downloadItems[index].state = .downloading
                downloadItems[index].progress = 0
                task.resume()
            }
        }
    }
    
    func pauseItem(item: ResumableDownloadItem) {
        let taskId = item.taskId
        session.getAllTasks { tasks in
            guard let task = tasks.first(where: {
                $0.taskIdentifier == taskId
            }) as? URLSessionDownloadTask else {
                return
            }

            task.cancel { [weak self] resumeData in
                guard let self else { return }

                DispatchQueue.main.async {
                    guard let index = self.downloadItems.firstIndex(
                        where: { $0.id == item.id }
                    ) else {
                        return
                    }

                    self.downloadItems[index].resumeData = resumeData
                    self.downloadItems[index].state = .paused

                    print("Resume data:", resumeData?.count ?? 0)
                }
            }
        }
    }
    
    func resumeItem(item: ResumableDownloadItem) {
        guard let index = self.downloadItems.firstIndex(
            where: { $0.id == item.id }
        ) else {
            return
        }
        if let resumeData = item.resumeData {
            let task = session.downloadTask(withResumeData: resumeData)
            downloadItems[index].state = .downloading
            downloadItems[index].taskId = task.taskIdentifier
            downloadItems[index].progress = 0
            task.resume()
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
                downloadState = .failed
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                downloadState = .completed
            }
            
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
        
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            downloadState = .completed
//        }
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
                if let index = downloadItems.firstIndex(where: {$0.taskId == downloadTask.taskIdentifier}) {
                    downloadItems[index].state = .completed
                    downloadItems[index].path = destination.absoluteString
                }
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
            if let index = downloadItems.firstIndex(where: {$0.taskId == downloadTask.taskIdentifier}) {
                downloadItems[index].progress = downloadedMB / expectedMB
            }
        }
            print(
                String(
                    format: "%.2f MB / %.2f MB",
                    downloadedMB,
                    expectedMB
                )
            )
        
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async { [weak self] in
            print("forBackgroundURLSession")
            guard let self = self else { return }
            self.backgroundCompletionHandler?()
            self.backgroundCompletionHandler = nil
        }
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

struct ResumableDownloadItem: Identifiable {
    let id: String
    var taskId: Int
    var state: DownloadState
    var path: String?
    var progress: Double?
    var resumeData: Data?
    
}
#Preview {
    ResumableDownloadView()
}
