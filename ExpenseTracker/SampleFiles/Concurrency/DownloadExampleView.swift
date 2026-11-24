//
//  DownloadExampleView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 24/11/26.
//

import SwiftUI

struct DownloadExampleView: View {
    @State var downloadList: [DownloadItem] = [
        .init(title: "My CV.pdf", isDownloaded: false, downloadProgress: 0),
        .init(title: "Adhaar.pdf", isDownloaded: false, downloadProgress: 0),
        .init(title: "License.pdf", isDownloaded: false, downloadProgress: 0)
    ]
    var body: some View {
        VStack {
            List(downloadList) { element in
                VStack {
                    Group {
                        Text(element.title)
                        if !element.isDownloaded {
                            Button("Start") {
                                
                                startDownload(item: element)
                            }
                        }
                    }
                    ProgressView(value: element.downloadProgress/100).progressViewStyle(.linear)
                }
            }
        }
        .padding(.horizontal,20)
    }
    
    func startDownload(item: DownloadItem) {
        guard let index = downloadList.firstIndex(of: item) else { return }
        
        Task {
            for i in 0...100 {
                try? await Task.sleep(for: .milliseconds(100))
                
                downloadList[index].downloadProgress = Double(i)
            }
            downloadList[index].isDownloaded = true
            
        }
    }
}

struct DownloadItem: Identifiable, Equatable {
    let id: UUID = UUID()
    let title: String
    var isDownloaded: Bool
    var downloadProgress: Double
}

#Preview {
    DownloadExampleView()
}
