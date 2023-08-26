//
//  ListsBuilder.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 18.04.2023.
//

import UIKit

struct ListsBuilder {
    
    static func build(router: ListsEvent) -> UIViewController & ListsViewInput {
        let coreData = CoreDataManager.instance
        let presenter = ListsPresenter(
            fetchedListsResultController: coreData.initListFetchedResultsController(),
            router: router
        )
        let listsCollectionDataSource = ListsCollectionDataSource()
        let listsCollectionDelegate = ListsCollectionDelegate()
        let searchResultsUpdating = ListSearchResultsController()
        
        let viewController = ListsViewController(
            presenter: presenter,
            listsCollectionDataSource: listsCollectionDataSource,
            listsCollectionDelegate: listsCollectionDelegate,
            searchResultsController: searchResultsUpdating
        )
        
        presenter.viewController = viewController
        listsCollectionDelegate.viewController = viewController
        listsCollectionDataSource.viewController = viewController
        searchResultsUpdating.viewController = viewController
        
        return viewController
    }
}
