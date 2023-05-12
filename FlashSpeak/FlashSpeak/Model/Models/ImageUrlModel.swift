//
//  ImageUrlModel.swift
//  FlashSpeak
//
//  Created by Алексей Ходаков on 17.04.2023.
//

import Foundation

// MARK: - ImageUrlModel
// struct ImageUrlModel: Codable {
//    let results: [Result]
// }

// MARK: - Result
// struct Result: Codable {
//    let urls: Urls
// }

// MARK: - Urls
// struct Urls: Codable {
//    let small: String
// }

// MARK: - Alias name
// typealias ImageUrl = ImageUrlModel

struct ImageResponse: Decodable {
    var results: [ImageResult]
}

struct ImageResult: Decodable {
    var urls: URLImage
}

struct URLImage: Decodable {
    /// Height 2000+ px
    var full: URL
    /// Height 1080 px
    var regular: URL
    /// Height 400 px
    var small: URL
    /// Height 200 px
    var thumb: URL
}

typealias TranslatedImages = ImageResponse

/*
 {
     "total": 85,
     "total_pages": 22,
     "results": [
         {
             "urls": {
                        "raw":
 */
