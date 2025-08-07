//
//  ImageModel.swift
//  NapWorkAssignment
//
//  Created by ISDP on 07/08/25.
//

import Foundation
import FirebaseFirestore

struct ImageModel: Codable {
    @DocumentID var id: String?
    let imageURL: String
    let referenceName: String
    let timestamp: Timestamp
    
    init(imageURL: String, referenceName: String) {
        self.imageURL = imageURL
        self.referenceName = referenceName
        self.timestamp = Timestamp()
    }
}
