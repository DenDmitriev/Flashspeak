//
//  LanguageTableDataSource.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import UIKit

class LanguageTableDataSource: NSObject, UITableViewDataSource {
    
    var viewInput: (UIViewController & LanguageViewInput)?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Language.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: LanguageCell.identifier,
                for: indexPath
            ) as? LanguageCell,
            let language = viewInput?.languages[indexPath.row]
        else { return UITableViewCell() }
        
        cell.configure(language: language)

        if let targetLanguage = viewInput?.language {
            if language.code == targetLanguage.code {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .bottom)
            }
        }
        
        return cell
    }
    
}
