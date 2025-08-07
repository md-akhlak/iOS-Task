//
//  FirebaseService.swift
//  NapWorkAssignment
//
//  Created by ISDP on 07/08/25.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import UIKit

class FirebaseService {
    static let shared = FirebaseService()
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    private init() {}
    
    // MARK: - Upload Image
    func uploadImage(_ image: UIImage, referenceName: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image to data")
            completion(.failure(NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])))
            return
        }
        
        let storageRef = storage.reference()
        let imageRef = storageRef.child("images/\(UUID().uuidString).jpg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imageRef.putData(imageData, metadata: metadata) { [weak self] metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            
            imageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
                
                guard let downloadURL = url?.absoluteString else {
                    completion(.failure(NSError(domain: "URLError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL"])))
                    return
                }
                
                
                self?.saveImageMetadata(imageURL: downloadURL, referenceName: referenceName) { result in
                    switch result {
                    case .success:
                        completion(.success(downloadURL))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    // MARK: - Save Image Metadata
    private func saveImageMetadata(imageURL: String, referenceName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let imageModel = ImageModel(imageURL: imageURL, referenceName: referenceName)
        
        do {
            try db.collection("images").addDocument(from: imageModel) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    // MARK: - Fetch Images
    func fetchImages(completion: @escaping (Result<[ImageModel], Error>) -> Void) {
        db.collection("images")
        .order(by: "timestamp", descending: false)  // Changed to false for ascending order
        .addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }
            let images: [ImageModel] = documents.compactMap { document in
                try? document.data(as: ImageModel.self)
            }
            
            completion(.success(images))
        }
    }
}
