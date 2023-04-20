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
    let small: String
}

// MARK: - Alias name
typealias ImageUrl = ImageUrlModel
