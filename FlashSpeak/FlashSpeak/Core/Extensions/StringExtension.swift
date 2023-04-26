//
//  StringExtension.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 22.04.2023.
//

import Foundation

extension String {
    
    /// Cleaning text punctuation marks
    func cleanText() -> String {
        var output = [String]()
        self.enumerateSubstrings(
            in: self.startIndex ..< self.endIndex,
            options: .byWords
        ) { substring, _, _, _ in
            if let substring = substring {
                return output.append(substring)
            }
        }
        return output.joined(separator: " ")
    }
}
