//
//  ImagesView.swift
//  iOS Task
//
//  Created by Md Akhlak on 15/08/25.
//

import Foundation
import SwiftUI

struct ImagesView: View {
    @StateObject private var viewModel = FetchImagesViewModel()
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.images) { image in
                    VStack {
                        ImageView(urlString: image.imageURL)
                        Text(image.referenceName)
                            .font(.footnote)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Images")
        .onAppear {
            viewModel.fetchImages()
        }
    }
}


struct ImageView: View {
    let urlString: String

    @StateObject private var loader = Cache()
    @StateObject private var viewModel = FetchImagesViewModel()

    var body: some View {
        ZStack {
            if let ui = loader.image {
                Image(uiImage: ui)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: 180)
                    .frame(height: 200)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.12))
                    .frame(maxWidth: 180)
                    .clipped()
                    .frame(height: 200)
                    .overlay(ProgressView())
            }
        }
        .onAppear {
            if let url = URL(string: urlString) {
                loader.load(from: url)
            }
            
        }
    }
}


#Preview {
    ImagesView()
}

