//
//  URLImage.swift
//  HackNC2020
//
//  Created by Samuel Shi on 10/18/20.
//

import SwiftUI

struct URLImage: View {
    @ObservedObject private var imageLoader = ImageLoader()
    
    var placeholder: Image
        
    init(url: String?, placeholder: Image = Image(systemName: "photo")) {
        self.placeholder = placeholder
        imageLoader.fetchImage(url: url)
    }

    var body: some View {
        
        if let image = self.imageLoader.image {
            return AnyView(
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipped()
            )
        }
        
        return AnyView(placeholder)
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    func fetchImage(url: String?) {
        guard let url = url else {
            return
        }
        
        guard let imageURL = URL(string: url) else {
            fatalError("invalid url string")
        }
                
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            guard let data = data, error == nil else {
                fatalError("error reading the image")
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}

