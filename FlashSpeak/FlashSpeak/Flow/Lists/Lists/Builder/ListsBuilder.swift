//
//  ListsBuilder.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 18.04.2023.
//

import UIKit

struct ListsBuilder {
    
    static func build() -> (UIViewController & ListsViewInput & ListsEvent) {
        let coreData = CoreDataManager.instance
        let presenter = ListsPresenter(
            fetchedListsResultController: coreData.initListFetchedResultsController()
        )
        let listsCollectionDataSource = ListsCollectionDataSource()
        let listsCollectionDelegate = ListsCollectionDelegate()
        
        let viewController = ListsViewController(presenter: presenter, listsCollectionDataSource: listsCollectionDataSource, listsCollectionDelegate: listsCollectionDelegate)
        
        presenter.viewController = viewController
        listsCollectionDelegate.viewController = viewController
        listsCollectionDataSource.viewController = viewController
        
        return viewController
    }
}
