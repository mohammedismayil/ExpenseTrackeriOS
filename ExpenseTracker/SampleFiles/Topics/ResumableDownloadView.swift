//
//  ResumableDownloadView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 11/08/26.
//

import SwiftUI
import Combine
import QuickLook

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
                Text("Download")
            }.onTapGesture {
                downloader.dowload()
                
            }
        }
            
    }
}

final class ResumableDownloader: NSObject, ObservableObject {
    @Published var path: String = ""
    
     lazy var session: URLSession = {
         URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }()
    
    func dowload() {
        if let url = URL(string: "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf") {
            let urlRequest = URLRequest(url: url)
            let task = session.downloadTask(with: urlRequest)
            task.resume()
        }
    }
}
extension ResumableDownloader: URLSessionDownloadDelegate, URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: (any Error)?) {
        if error != nil {
            print("File error")
        } else {
            print("download compltetd")
        }
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let fileManager = FileManager.default
        do {
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let destination = documentsURL.appendingPathComponent("Sample.pdf")
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
