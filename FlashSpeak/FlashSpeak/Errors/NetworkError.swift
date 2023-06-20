//
//  NetworkError.swift
//  FlashSpeak
//
//  Created by Алексей Ходаков on 17.04.2023.
//

import Foundation

enum NetworkError: LocalizedError {
    case network(description: String)
    case unreachableAddress(url: String)
    case emptyURL
    case invalidResponse
    case decodingError
    case unwrap
    case unknownError(error: Error)
    case imageDecodingError(error: Error)
    
    var errorDescription: String? {
        switch self {
        case .network(description: let description):
            return description
        case .unreachableAddress(let url):
            return NSLocalizedString("Unreachable url", comment: "Error") + url
        case .emptyURL:
            return NSLocalizedString("URL is nil", comment: "Error")
        case .decodingError:
            return NSLocalizedString("Decoding error", comment: "Error")
        case .invalidResponse:
            return NSLocalizedString("Response with mistake", comment: "Error")
        case .unknownError(let error):
            return error.localizedDescription
        case .imageDecodingError(let error):
            return NSLocalizedString("Image decoding error", comment: "Error") + error.localizedDescription
        case .unwrap:
            return NSLocalizedString("Data must not be nil", comment: "Error")
        }
    }
}
