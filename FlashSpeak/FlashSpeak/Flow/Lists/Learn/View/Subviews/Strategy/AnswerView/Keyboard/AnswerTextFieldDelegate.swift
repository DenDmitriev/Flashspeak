//
//  AnswerTextFieldDelegate.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 19.05.2023.
//
// swiftlint:disable line_length

import UIKit

class AnswerTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    weak var view: AnswerKeyboardViewStrategy?
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view?.didAnswer()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text?.lowercased() else { return true }
        var cleanedText = (text + string).cleanText()
        if cleanedText.last == " " {
            cleanedText.removeLast()
        }
        view?.answer?.answer = cleanedText
        return true
    }
}

// swiftlint:enable line_length
