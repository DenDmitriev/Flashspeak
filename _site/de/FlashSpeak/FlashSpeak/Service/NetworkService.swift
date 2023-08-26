//
//  NetworkService.swift
//  FlashSpeak
//
//  Created by Алексей Ходаков on 17.04.2023.
//

import Foundation
import Combine
import UIKit

// MARK: - NetworkServiceProtocol
protocol NetworkServiceProtocol {
    func translateWordsWithGoogle(url: URL) -> AnyPublisher<TransalateResponse, NetworkError>
    func getImageURL(url: URL) -> AnyPublisher<ImageUrlModel, NetworkError>
    func imageLoader(url: URL) -> AnyPublisher<UIImage?, NetworkError>
}

class NetworkService: NetworkServiceProtocol {
    
    // MARK: - Public functions
    func translateWordsWithGoogle(url: URL) -> AnyPublisher<TransalateResponse, NetworkError> {
        URLSession.shared.publisher(for: url, queue: "translateWords")
    }
    
    func getImageURL(url: URL) -> AnyPublisher<ImageUrlModel, NetworkError> {
        URLSession.shared.publisher(for: url, queue: "getImageUrl")
    }
    
    func imageLoader(url: URL) -> AnyPublisher<UIImage?, NetworkError> {
        URLSession.shared
            .dataTaskPublisher(for: url)
            .mapError({ error -> NetworkError in
                switch error {
                default:
                    return NetworkError.unknownError(error: error)
                }
            })
            .map { data, _ in UIImage(data: data) }
            .eraseToAnyPublisher()
    }
}
