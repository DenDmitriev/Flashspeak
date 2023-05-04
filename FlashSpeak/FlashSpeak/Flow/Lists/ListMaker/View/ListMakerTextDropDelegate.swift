//
//  ListMakerTextDropDelegate.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 24.04.2023.
//
// swiftlint:disable line_length

import UIKit

class ListMakerTextDropDelegate: NSObject, UITextDropDelegate {
    
    weak var viewController: (UIViewController & ListMakerViewInput)?
    
    func textDroppableView(_ textDroppableView: UIView & UITextDroppable, dropSessionDidEnd session: UIDropSession) {
        session.items.forEach { dragitem in
            guard
                let item = dragitem.localObject as? String,
                let textField = textDroppableView as? UITextField,
                textField.text == item
            else { return }
            viewController?.deleteToken(token: item)
        }
    }
}

// swiftlint:enable line_length
