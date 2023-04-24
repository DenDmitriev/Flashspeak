//
//  WordCardsBuilder.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import UIKit

struct WordCardsBuilder {
    
    static func build(list: List) -> (UIViewController & WordCardsViewInput) {
        let presenter = WordCardsPresenter()
        let collectionDelegate = WordCardsCollectionDelegate()
        let collectionDataSource = WordCardsCollectionDataSource()
        
        let viewController = WordCardsViewController(list: list, presenter: presenter, wordCardsCollectionDataSource: collectionDataSource, wordCardsCollectionDelegate: collectionDelegate)
        
        presenter.viewInput = viewController
        collectionDelegate.viewInput = viewController
        collectionDataSource.viewInput = viewController
        
        return viewController
    }
}