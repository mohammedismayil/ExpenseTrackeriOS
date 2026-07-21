//
//  PhotosListView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 06/07/26.
//

import SwiftUI
import Combine

struct PhotosListView: View {
    @StateObject var viewModel: PhotosListViewModel = PhotosListViewModel()
    var body: some View {
        NavigationStack {
            List() {
                ForEach(viewModel.photos) { photo in
                    CatalogView(viewModel: PhotoViewModel(photo: photo))
                }
            }
        }
        .navigationTitle("Photos List")
        .task {
            await viewModel.fetchPhotos()
        }
        
    }
}

class PhotosListViewModel : ObservableObject {
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

class PhotoViewModel: ObservableObject {
    @Published var photo: PhotoModel
    @Published var error: Error?
    
    init(photo: PhotoModel, error: Error? = nil) {
        self.photo = photo
        self.error = error
    }
    
    func fetchPhoto() async {
        let url = photo.url
        do {
            let (_,resp) = try await URLSession.shared.data(from: url)
            if let response = resp as? HTTPURLResponse, response.statusCode == 200 {
            } else {
                error = PhotoError.decodeError
            }
        } catch {
            self.error = PhotoError.decodeError
        }
        
    }
}

struct CatalogView: View {
    @StateObject var viewModel: PhotoViewModel
    var body: some View {
        VStack {
            if let _ = viewModel.error {
                Text("Photo fetch error")
            } else {
                AsyncImage(url: viewModel.photo.url) { image in
                    image.resizable().frame(width: 200, height: 200).aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                Text(viewModel.photo.title)
                if #available(iOS 26.0, *) {
                    Button("Save") {
                        
                    }.buttonStyle(.glassProminent)
                } else {
                    // Fallback on earlier versions
                }
            }
            
        }
        .background(.thickMaterial)
        .mask(RoundedRectangle(cornerRadius: 16))
        .padding(.bottom,8)
        .task {
            await viewModel.fetchPhoto()
        }
       
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
