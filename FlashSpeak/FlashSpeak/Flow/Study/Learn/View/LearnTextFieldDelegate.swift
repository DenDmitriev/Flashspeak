//
//  LearnTextFieldDelegate.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 06.05.2023.
//
// swiftlint:disable line_length

import UIKit

class LearnTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    weak var viewController: (UIViewController & LearnViewInput)?
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewController?.keyboardDidAnswer()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text?.lowercased() else { return true }
        viewController?.answer.answer = text
        return true
    }
}

// swiftlint:enable line_length
