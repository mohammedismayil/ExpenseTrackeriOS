//
//  GCDImageFetchView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 10/08/26.
//

import SwiftUI

struct GCDImage: Identifiable {
    let id: String
    var isLoaded: Bool
    var name: String
}

struct GCDImageFetchView: View {
    
    @State var images: [GCDImage] = [GCDImage(id: "1", isLoaded: false, name: "1"),GCDImage(id: "2", isLoaded: false, name: "1"),GCDImage(id: "3", isLoaded: false, name: "1"),GCDImage(id: "4", isLoaded: false, name: "1"),GCDImage(id: "5", isLoaded: false, name: "1")]
    @State var completedCount: Int = 0
    var body: some View {
        VStack {
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(images){ image in
                        Text(image.name)
                        Color(.orange).frame(width: 100, height: 100).containerShape(.buttonBorder)
                        if image.isLoaded {
                            Image("image\(image.name)").resizable().frame(width: 100,height: 100)
                        } else {
                            ProgressView()
                        }
                    }
                }
                
            }
            Text("Total loaded images: \(completedCount)")
            Button("Start Processing") {
                // GCD code will come here
                let queue = DispatchQueue(label: "image", attributes: .concurrent)
                for i in 0..<images.count {
                    queue.async {
                        print("\(i+1) image download")
                        Thread.sleep(forTimeInterval: .random(in: 0...3))
                        DispatchQueue.main.async {
                            images[i].isLoaded = true
                            completedCount += 1
                            print("\(i+1)st image loaded")
                        }
                    }
                }
            }
            
            Button("Cancel") {
                // cancellation
            }
        }
    }
}

#Preview {
    GCDImageFetchView()
}
