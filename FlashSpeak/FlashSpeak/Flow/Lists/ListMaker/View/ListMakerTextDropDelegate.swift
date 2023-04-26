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
            if let item = dragitem.localObject as? String {
                viewController?.deleteToken(token: item)
            }
        }
        viewController?.hideRemoveArea(isHidden: true)
    }
}

// swiftlint:enable line_length
