//
//  ExhibitProduct.swift
//  Expo1900
//
//  Created by Seungjin Baek on 2021/04/09.
//

import Foundation

struct ExhibitionProduct: Decodable {
    let name, imageName, shortDescription, description: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case imageName = "image_name"
        case shortDescription = "short_desc"
        case description = "desc"
    }
}

struct ExhibitionContent: Decodable {
    let images: [Image]
    let info: Information
    
    struct Image: Decodable {
        let fileName: String
        let deviceType: String
        let imageSize: String
        
        enum CodingKeys: String, CodingKey {
            case fileName = "filename"
            case deviceType = "idiom"
            case imageSize = "scale"
        }
    }
    
    struct Information: Decodable {
        let author: String
        let version: Int
    }
}

struct ExhibitionExplanation: Decodable {
    let title, location, duration, description: String
    let visitors: Int
}
