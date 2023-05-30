//
//  ListMenuAction.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 18.05.2023.
//

import Foundation
import UIKit.UIImage

struct ListMenu {
    
    enum Action: CaseIterable {
        case editCards
        case editWords
        case transfer
        case delete
        
        var title: String {
            switch self {
            case .delete:
                return NSLocalizedString("Delete", comment: "Menu")
            case .editCards:
                return NSLocalizedString("Edit cards", comment: "Menu")
            case .editWords:
                return NSLocalizedString("Edit words", comment: "Menu")
            case .transfer:
                return NSLocalizedString("Transfer", comment: "Menu")
            }
        }
        
        var image: UIImage? {
            switch self {
            case .delete:
                return UIImage(systemName: "minus.circle")
            case .editCards:
                return UIImage(systemName: "square.and.pencil")
            case .editWords:
                return UIImage(systemName: "pencil")
            case .transfer:
                return UIImage(systemName: "square.and.arrow.up")
            }
        }
    }
    
    func menu(closure: ((Action) -> Void)?) -> UIMenu {
        var menuElements = [UIMenuElement]()
        Action.allCases.forEach { listMenu in
            let action = UIAction(title: listMenu.title, image: listMenu.image) { _ in
                switch listMenu {
                case .editCards:
                    closure?(.editCards)
                case .editWords:
                    closure?(.editWords)
                case .transfer:
                    closure?(.transfer)
                case .delete:
                    closure?(.delete)
                }
            }
            menuElements.append(action)
        }
        return UIMenu(children: menuElements)
    }
}
