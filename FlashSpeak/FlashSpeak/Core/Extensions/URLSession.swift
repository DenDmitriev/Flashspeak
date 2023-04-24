//
//  URLSession.swift
//  FlashSpeak
//
//  Created by Алексей Ходаков on 17.04.2023.
//

import Foundation
import Combine

// MARK: - URLSession
extension URLSession {
    func publisher<T: Decodable>(
        for url: URL,
        queue label: String,
        responseType: T.Type = T.self,
        decoder: JSONDecoder = .init()
    ) -> AnyPublisher<T, NetworkError> {
        dataTaskPublisher(for: url)
            .receive(on: DispatchQueue(label: label, qos: .default, attributes: .concurrent))
            .map(\.data)
            .decode(type: NetworkResponse<T>.self, decoder: decoder)
            .mapError({ error -> NetworkError in
                switch error  {
                case is URLError:
                    return NetworkError.unreachableAddress(url: url.description)
                case is DecodingError:
                    return NetworkError.decodingError
                default:
                    return NetworkError.invalidResponse
                }
            })
            .map({
                guard let value = $0.wrappedValue
                else { fatalError("Value not found") }
                return value
            })
            .eraseToAnyPublisher()
    }
}
