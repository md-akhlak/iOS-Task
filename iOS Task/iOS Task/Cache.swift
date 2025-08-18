//
//  ImageLoader.swift
//  iOS Task
//
//  Created by Cache on 15/08/25.
//

import Foundation
import SwiftUI


class Cache: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading: Bool = false

    private static let cache = NSCache<NSURL, UIImage>()
    private var task: URLSessionDataTask?

    
    func load(from url: URL) {
        if let cached = Self.cache.object(forKey: url as NSURL) {
            image = cached
            return
        }
        isLoading = true
        fetchImage(url: url)
    }

    private func fetchImage(url: URL) {
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData

        task?.cancel()
        task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }

            if let data = data, let uiImage = UIImage(data: data) {
                Self.cache.setObject(uiImage, forKey: url as NSURL)
                DispatchQueue.main.async {
                    self.image = uiImage
                    self.isLoading = false
                }
            } else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
        task?.resume()
    }

    deinit {
        task?.cancel()
    }
}

