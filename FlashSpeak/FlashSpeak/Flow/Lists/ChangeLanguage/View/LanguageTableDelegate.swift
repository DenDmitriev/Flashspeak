//
//  LanguageTableDelegate.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import UIKit

class LanguageTableDelegate: NSObject, UITableViewDelegate {
    
    weak var viewInput: (UIViewController & LanguageViewInput)?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewInput?.didSelectItem(indexPath: indexPath)
    }
}
