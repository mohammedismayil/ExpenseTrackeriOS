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
    var body: some View {
        VStack {
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(images){ image in
                        Text(image.name)
                        Color(.orange).frame(width: 100, height: 100).containerShape(.buttonBorder)
                        if image.isLoaded {
                            Image("image\(image.name)").resizable().frame(height: 100)
                        } else {
                            ProgressView()
                        }
                    }
                }
                
            }
            Button("Start Processing") {
                // GCD code will come here
                let queue = DispatchQueue(label: "image", attributes: .concurrent)
                queue.async {
                    print("1st image download")
                    Thread.sleep(forTimeInterval: .random(in: 0...3))
                    images[0].isLoaded = true
                    print("1st image loaded")
                }
                queue.async {
                    print("2st image download")
                    Thread.sleep(forTimeInterval: .random(in: 0...3))
                    images[1].isLoaded = true
                    print("2st image loaded")
                }
                queue.async {
                    print("3st image download")
                    Thread.sleep(forTimeInterval: .random(in: 0...3))
                    DispatchQueue.main.async {
                        images[2].isLoaded = true
                        print("3st image loaded")
                    }
                   
                }
                queue.async {
                    print("4st image download")
                    Thread.sleep(forTimeInterval: .random(in: 0...3))
                    images[3].isLoaded = true
                    print("4st image loaded")
                }
                queue.async {
                    print("5st image download")
                    Thread.sleep(forTimeInterval: .random(in: 0...3))
                    images[4].isLoaded = true
                    print("5st image loaded")
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
