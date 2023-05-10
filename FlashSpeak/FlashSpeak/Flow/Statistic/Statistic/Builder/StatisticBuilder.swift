//
//  StatisticBuilder.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 10.05.2023.
//

import UIKit

struct StatisticBuilder {
    static func build(router: StatisticEvent) -> UIViewController & StatisticViewInput {
        let presenter = StatisticPresenter(router: router)
        let collectionViewDataSource = StatisticsCollectionViewDataSource()
        let collectionViewDelegate = StatisticsCollectionViewDelegate()
        
        let viewController = StatisticsViewController(
            presenter: presenter,
            collectionViewDataSource: collectionViewDataSource,
            collectionViewDelegate: collectionViewDelegate
        )
        
        presenter.viewController = viewController
        collectionViewDelegate.viewController = viewController
        collectionViewDataSource.viewController = viewController
        
        return viewController
    }
}
