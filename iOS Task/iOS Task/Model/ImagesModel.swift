//
//  ImagesModel.swift
//  iOS Task
//
//  Created by Md Akhlak on 15/08/25.
//

import Foundation

struct ImageModel: Identifiable {
    let id: String
    let imageURL: String
    let referenceName: String
    let timestamp: Date
}
