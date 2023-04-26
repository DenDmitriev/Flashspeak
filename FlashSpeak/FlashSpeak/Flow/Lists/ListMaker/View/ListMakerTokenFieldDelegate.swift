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
            string.components(separatedBy: ",").forEach { word in
                viewController?.addToken(token: word.lowercased())
            }
            return false
        /// Keyboard typing with "," action
        case ",":
            guard
                let word = textField.text?.lowercased()
            else { return true }
            viewController?.addToken(token: word)
            textField.text = nil
            return false
        default:
            return true
        }
    }
}

// swiftlint:enable line_length
