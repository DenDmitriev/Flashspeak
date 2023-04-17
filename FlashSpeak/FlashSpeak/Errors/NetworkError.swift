//
//  NetworkError.swift
//  FlashSpeak
//
//  Created by Алексей Ходаков on 17.04.2023.
//

import Foundation

enum NetworkError: LocalizedError {
    case unreachableAddress(url: String)
    case invalidResponse
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .unreachableAddress(let url):
            return"\(url) is unreachable"
        case .decodingError:
            return "Decoding error"
        case .invalidResponse:
            return "Response with mistake" }
    }
}
