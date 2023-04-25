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
    func translateWords(url: URL) -> AnyPublisher<TranslatedWords, NetworkError>
    func getImageUrl(url: URL) -> AnyPublisher<ImageUrl, NetworkError>
    func imageLoader(url: URL) -> AnyPublisher<UIImage?, Never>
}

class NetworkService: NetworkServiceProtocol {
    
    // MARK: - Public functions
    func translateWords(url: URL) -> AnyPublisher<TranslatedWords, NetworkError> {
        URLSession.shared.publisher(for: url, queue: "translateWords")
    }
    
    func getImageUrl(url: URL) -> AnyPublisher<ImageUrl, NetworkError> {
        URLSession.shared.publisher(for: url, queue: "getImageUrl")
    }
    
    func imageLoader(url: URL) -> AnyPublisher<UIImage?, Never> {
        URLSession.shared
            .dataTaskPublisher(for: url)
            .map { data, _ in UIImage(data: data) }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}
