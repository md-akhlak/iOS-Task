//
//  ImagesView.swift
//  iOS Task
//
//  Created by Md Akhlak on 15/08/25.
//

import Foundation
import SwiftUI

struct ImagesView: View {
    @StateObject private var viewModel = ImagesViewModel()
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.images) { image in
                    VStack {
                        ImageView(urlString: image.url)
                        Text(image.name)
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

#Preview {
    ImagesView()
}
