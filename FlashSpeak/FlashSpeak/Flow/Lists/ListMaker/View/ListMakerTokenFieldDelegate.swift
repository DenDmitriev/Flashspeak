//
//  ListMakerTokenFieldDelegate.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 21.04.2023.
//
// swiftlint:disable line_length

import UIKit

class ListMakerTokenFieldDelegate: NSObject, UITextFieldDelegate {
    
    weak var viewController: (UIViewController & ListMakerViewInput)?
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch string {
        /// Paste text seporated by ","
        case UIPasteboard.general.string:
            let wordsByComma = string.components(separatedBy: ",")
            addTokens(wordsByComma)
            return false
            
        /// Paste text seporated by new line "\n"
        case UIPasteboard.general.string?.components(separatedBy: "\n").joined(separator: " "):
            let wordsByNewLine = string.components(separatedBy: " ")
            addTokens(wordsByNewLine)
            return false
            
        /// Keyboard typing with "," action
        case ",":
            addToken(textField.text)
            return false
        default:
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addToken(textField.text)
        return true
    }
    
    // MARK: - Private functions
    
    private func addTokens(_ tokens: [String]) {
        tokens.forEach { word in
            viewController?.addToken(token: word.lowercased())
        }
    }
    
    private func addToken(_ token: String?) {
        guard
            let token = token
        else { return }
        addTokens([token])
    }
}

// swiftlint:enable line_length
