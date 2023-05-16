//
//  CardBuilder.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 15.05.2023.
//

import UIKit

struct CardBuilder {
    static func build(word: Word, style: GradientStyle, router: CardEvent) -> UIViewController & CardViewInput {
        
        let presenter = CardPresenter(word: word, style: style, router: router)
        let collectionViewDelegate = CardCollectionDelegate()
        let collectionViewDataSource = CardCollectionDataSource()
        
        let viewController = CardViewController(
            presenter: presenter,
            collectionDataSource: collectionViewDataSource,
            collectionDelegate: collectionViewDelegate
        )
        
        presenter.viewController = viewController
        collectionViewDelegate.viewController = viewController
        collectionViewDataSource.viewController = viewController
        
        return viewController
    }
}
