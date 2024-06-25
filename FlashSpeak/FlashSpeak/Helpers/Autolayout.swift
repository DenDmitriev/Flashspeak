//
//  Autolayout.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 25.06.2024.
//

import UIKit

@propertyWrapper
public struct Autolayout<T: UIView> {
    public var wrappedValue: T {
        didSet {
            translatesAutoresizingMaskIntoConstraints()
        }
    }

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        translatesAutoresizingMaskIntoConstraints()
    }

    private func translatesAutoresizingMaskIntoConstraints() {
        wrappedValue.translatesAutoresizingMaskIntoConstraints = false
    }
}

