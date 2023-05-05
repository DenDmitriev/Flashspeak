//
//  StudyBuilder.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 27.04.2023.
//

import UIKit

struct StudyBuilder {
    
    static func build(router: StudyEvent) -> (UIViewController & StudyViewInput) {
        let coreData = CoreDataManager.instance
        let presenter = StudyPresenter(
            router: router,
            fetchedListsResultController: coreData.initListFetchedResultsController()
        )
        let collectionDelegate = StudyCollectionDelegate()
        let collectionDataSource = StudyCollectionDataSource()
        
        let viewController = StudyViewController(
            presenter: presenter,
            studyCollectionDataSource: collectionDataSource,
            studyCollectionDelegate: collectionDelegate
        )
        
        presenter.viewInput = viewController
        collectionDelegate.viewInput = viewController
        collectionDataSource.viewInput = viewController
        
        return viewController
    }
}
