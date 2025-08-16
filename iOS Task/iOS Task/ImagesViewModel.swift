//
//  ImagesViewModel.swift
//  iOS Task
//
//  Created by Md Akhlak on 15/08/25.
//

import Foundation
import Foundation
import FirebaseFirestore

class ImagesViewModel: ObservableObject {
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
                    return ImageModel(id: doc.documentID, url: url, name: name, timestamp: timestamp.dateValue())
                } ?? []
                self.images = newImages
                self.prefetchRecentImages(limit: 6)
            }
    }
    
    private func prefetchRecentImages(limit: Int) {
        let recent = images.suffix(limit)
        for item in recent {
            guard let url = URL(string: item.url) else { continue }
            var request = URLRequest(url: url)
            request.cachePolicy = .reloadIgnoringLocalCacheData
            let task = URLSession.shared.dataTask(with: request) { _, _, _ in }
            task.resume()
        }
    }
}
