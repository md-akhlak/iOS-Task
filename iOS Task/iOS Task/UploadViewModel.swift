//
//  UploadViewModel.swift
//  iOS Task
//
//  Created by Md Akhlak on 15/08/25.
//

import Foundation
import Foundation
import FirebaseStorage
import FirebaseFirestore
import UIKit

class UploadViewModel: ObservableObject {
    private let storage = Storage.storage()
    private let db = Firestore.firestore()
    @Published var isUploading: Bool = false
    @Published var errorMessage: String?
    @Published var didFinishUpload: Bool = false
    
    func uploadImage(image: UIImage, name: String) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        let storageRef = storage.reference().child("images/\(UUID().uuidString).jpg")
        isUploading = true
        didFinishUpload = false
        errorMessage = nil
        storageRef.putData(imageData, metadata: nil) {[weak self] metadata, error in
            if let error = error {
                print("Error uploading image: \(error)")
                DispatchQueue.main.async {
                    self?.isUploading = false
                    self?.errorMessage = error.localizedDescription
                }
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error)")
                    DispatchQueue.main.async {
                        self?.isUploading = false
                        self?.errorMessage = error.localizedDescription
                    }
                    return
                }
                
                guard let url = url else { return }
                
                self?.saveToFirestore(url: url.absoluteString, name: name)
            }
        }
    }
    
    private func saveToFirestore(url: String, name: String) {
        let data: [String: Any] = [
            "url": url,
            "name": name,
            "timestamp": Timestamp(date: Date())
        ]
        
        db.collection("images").addDocument(data: data) {[weak self] error in
            if let error = error {
                print("Error saving to Firestore: \(error)")
                DispatchQueue.main.async {
                    self?.isUploading = false
                    self?.errorMessage = error.localizedDescription
                }
            }
            DispatchQueue.main.async {
                self?.isUploading = false
                self?.didFinishUpload = true
            }
        }
    }
}
