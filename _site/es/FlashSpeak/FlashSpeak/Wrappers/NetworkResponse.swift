//
//  NetworkResponse.swift
//  FlashSpeak
//
//  Created by Алексей Ходаков on 17.04.2023.
//

import Foundation

@propertyWrapper public struct NetworkResponse<T: Decodable>: Decodable {

    // MARK: - Public properties
    public let wrappedValue: T?
    
    // MARK: - Initialisation
    public init(from decoder: Decoder) throws {
        wrappedValue = try? T(from: decoder)
    }
    
    public init(_ wrappedValue: T?) {
        self.wrappedValue = wrappedValue
    }
}
