//
//  PrepareLearnBuilder.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 25.05.2023.
//

import UIKit

struct PrepareLearnBuilder {
    static func build(router: PrepareLearnEvent, list: List) -> UIViewController & PrepareLearnInput {
        let coreData = CoreDataManager.instance
        let presenter = PrepareLearnPresenter(
            router: router,
            list: list,
            fetchedListResultsController: coreData.initListFetchedResultsController()
        )
        
        let viewController = PrepareLearnViewController(
            presenter: presenter
        )
        
        presenter.viewController = viewController
        
        return viewController
    }
}
