//
//  ListsBuilder.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 18.04.2023.
//

import UIKit

struct ListsBuilder {
    
    static func build() -> (UIViewController & ListsViewInput) {
        let presenter = ListsPresenter()
        let listsCollectionDataSource = ListsCollectionDataSource()
        let listsCollectionDelegate = ListsCollectionDelegate()
        
        let viewController = ListsViewController(presenter: presenter, listsCollectionDataSource: listsCollectionDataSource, listsCollectionDelegate: listsCollectionDelegate)
        
        presenter.viewInput = viewController
        listsCollectionDelegate.viewController = viewController
        listsCollectionDataSource.viewController = viewController
        
        return viewController
    }
}
