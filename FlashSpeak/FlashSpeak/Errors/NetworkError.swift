//
//  NetworkError.swift
//  FlashSpeak
//
//  Created by Алексей Ходаков on 17.04.2023.
//

import Foundation

enum NetworkError: LocalizedError {
    case unreachableAddress(url: String)
    case emptyURL
    case invalidResponse
    case decodingError
    case unwrap
    case unknownError(error: Error)
    case imageDecodingError(error: Error)
    
    var errorDescription: String {
        switch self {
        case .unreachableAddress(let url):
            return "\(url) is unreachable"
        case .emptyURL:
            return "URL is nil"
        case .decodingError:
            return "Decoding error"
        case .invalidResponse:
            return "Response with mistake"
        case .unknownError(let error):
            return error.localizedDescription
        case .imageDecodingError(let error):
            return "Image decoding \(error)"
        case .unwrap:
            return "Data must not be nil"
        }
    }
}
