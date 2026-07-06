//
//  PhotosListView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 06/07/26.
//

import SwiftUI
import Combine

struct PhotosListView: View {
    @StateObject var viewModel: PhotosViewModel = PhotosViewModel()
    var body: some View {
        NavigationStack {
            List() {
                ForEach(viewModel.photos) { photo in
                    CatalogView(photo: photo)
                }
            }
        }
        .navigationTitle("Photos List")
        .task {
            await viewModel.fetchPhotos()
        }
        
    }
}

class PhotosViewModel : ObservableObject {
    @Published var photos: [PhotoModel] = []
    @Published var error: Error?
    
    func fetchPhotos() async {
        guard let url = URL(string: "https://picsum.photos/v2/list") else {
            error = PhotoError.urlFailed
            return
        }
        do {
            if let (data,resp) = try? await   URLSession.shared.data(from: url) {
                guard let re = resp as? HTTPURLResponse, re.statusCode == 200 else {
                    error = PhotoError.fetchError
                    return
                }
                if let model = try? JSONDecoder().decode([PhotoModel].self, from: data) {
                    self.photos = model
                } else {
                    error = PhotoError.decodeError
                }
            }
        }
    }
}

struct CatalogView: View {
    var photo: PhotoModel
    var body: some View {
        VStack {
            AsyncImage(url: photo.url) { image in
                image.resizable().frame(width: 200, height: 200).aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            Text(photo.title)
            Button("Save") {
                
            }.buttonStyle(.glassProminent)
        }
        .background(.thickMaterial)
        .mask(RoundedRectangle(cornerRadius: 16))
        .padding(.bottom,8)
       
    }
}

struct PhotoModel: Codable, Identifiable {
    let id: String
    let url: URL
    let title: String
    init(id: String, url: URL, title: String) {
        self.id = id
        self.url = url
        self.title = title
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case url = "download_url"
        case title = "author"
    }
}

enum PhotoError: Error {
    case urlFailed
    case decodeError
    case fetchError
}

#Preview {
    PhotosListView()
}
