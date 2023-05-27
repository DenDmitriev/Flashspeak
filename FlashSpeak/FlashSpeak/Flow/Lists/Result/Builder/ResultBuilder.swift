//
//  ResultBuilder.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 07.05.2023.
//

import UIKit

struct ResultBuilder {
    
    static func build(router: ResultEvent, learnings: [Learn]) -> (UIViewController & ResultViewInput) {
        
        let presenter = ResultPresenter(router: router, learnings: learnings)
        let gestureRecognizerDelegate = ResultGestureRecognizerDelegate()
        let resultCollectionViewDataSource = ResultsCollectionViewDataSource()
        let resultCollectionViewDelegate = ResultsCollectionViewDelegate()
        
        let viewController = ResultViewController(
            presenter: presenter,
            gestureRecognizerDelegate: gestureRecognizerDelegate,
            resultCollectionViewDataSource: resultCollectionViewDataSource,
            resultCollectionViewDelegate: resultCollectionViewDelegate
        )
        
        presenter.viewController = viewController
        resultCollectionViewDataSource.viewController = viewController
        resultCollectionViewDelegate.viewController = viewController
        
        return viewController
    }
}
