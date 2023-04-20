//
//  LanguageTableDataSource.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import UIKit

class LanguageTableDataSource: NSObject, UITableViewDataSource {
    
    private var viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Language.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LanguageCell.identifier, for: indexPath) as? LanguageCell else { return UITableViewCell() }
        
        let language = Language.allCases[indexPath.row]
        cell.configure(language: language)
        
        //Replace code for get user study language here
        if language.code == "en" {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .bottom)
        }
        
        return cell
    }
    
}
