//
//  ListMakerTokenFieldDelegate.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 21.04.2023.
//

import UIKit

class ListMakerTokenFieldDelegate: NSObject, UITextFieldDelegate {
    
    var viewController: (UIViewController & ListMakerViewInput)?
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch string {
        case UIPasteboard.general.string: //Paste text seporated by ","
            string.components(separatedBy: ",").forEach { word in
                viewController?.addToken(token: word)
            }
            return false
        case ",": //Keyboard typing with "," action
            guard let word = textField.text?.lowercased() else { return true }
            viewController?.addToken(token: word)
            textField.text = nil
            return false
        default:
            return true
        }
    }
}
