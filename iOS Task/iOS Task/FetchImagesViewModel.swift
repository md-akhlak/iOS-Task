//
//  ImagesViewModel.swift
//  iOS Task
//
//  Created by Md Akhlak on 15/08/25.
//

import Foundation
import Foundation
import FirebaseFirestore

class FetchImagesViewModel: ObservableObject {
    @Published var images: [ImageModel] = []
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    func fetchImages() {
        listener?.remove()
        listener = db.collection("images")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching images: \(error)")
                    return
                }
                let newImages: [ImageModel] = snapshot?.documents.compactMap { doc in
                    let data = doc.data()
                    guard let url = data["url"] as? String,
                          let name = data["name"] as? String,
                          let timestamp = data["timestamp"] as? Timestamp else {
                        return nil
                    }
                    return ImageModel(id: doc.documentID, imageURL: url, referenceName: name, timestamp: timestamp.dateValue())
                } ?? []
                self.images = newImages
                self.prefetchRecentImages()
            }
    }
    
    private func prefetchRecentImages() {
        let recent = images.suffix(1)
        for item in recent {
            guard let url = URL(string: item.imageURL) else { continue }
            var request = URLRequest(url: url)
            request.cachePolicy = .reloadIgnoringLocalCacheData
            let task = URLSession.shared.dataTask(with: request) { _, _, _ in }
            task.resume()
        }
    }
}
