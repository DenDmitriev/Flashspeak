//
//  ListMenu.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 18.05.2023.
//

import Foundation
import UIKit.UIImage

enum ListMenu: CaseIterable {
    case delete
    
    var title: String {
        switch self {
        case .delete:
            return NSLocalizedString("Удалить", comment: "Menu")
        }
    }
    
    var image: UIImage? {
        switch self {
        case .delete:
            return UIImage(systemName: "trash")
        }
    }
}
