//
//  WordMenu.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 24.05.2023.
//

import Foundation
import UIKit.UIImage

struct WordMenu {
    
    enum Action: CaseIterable {
        case edit
        case delete
        
        var title: String {
            switch self {
            case .delete:
                return NSLocalizedString("Удалить", comment: "Menu")
            case .edit:
                return NSLocalizedString("Редактировать", comment: "Menu")
            }
        }
        
        var image: UIImage? {
            switch self {
            case .delete:
                return UIImage(systemName: "minus.circle")
            case .edit:
                return UIImage(systemName: "pencil")
            }
        }
    }

    func menu(closure: ((Action) -> Void)?) -> UIMenu {
        var menuElements = [UIMenuElement]()
        Action.allCases.forEach { wordMenu in
            let action = UIAction(title: wordMenu.title, image: wordMenu.image) { _ in
                switch wordMenu {
                case .edit:
                    closure?(.edit)
                case .delete:
                    closure?(.delete)
                }
            }
            menuElements.append(action)
        }
        return UIMenu(children: menuElements)
    }
}
