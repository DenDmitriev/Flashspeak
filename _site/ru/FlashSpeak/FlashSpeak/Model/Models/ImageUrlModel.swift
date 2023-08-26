//
//  ImageUrlModel.swift
//  FlashSpeak
//
//  Created by Алексей Ходаков on 17.04.2023.
//

import Foundation

// MARK: - ImageUrlModel
struct ImageUrlModel: Codable {
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let urls: Urls
}

// MARK: - Urls
struct Urls: Codable {
    /// Height 2000+ px
    let full: URL
    /// Height 1080 px
    let regular: URL
    /// Height 400 px
    let small: URL
    /// Height 200 px
    let thumb: URL
}

// MARK: - Alias name
typealias ImageUrl = ImageUrlModel


/*
 {
     "total": 85,
     "total_pages": 22,
     "results": [
         {
             "urls": {
                        "raw":
 */
