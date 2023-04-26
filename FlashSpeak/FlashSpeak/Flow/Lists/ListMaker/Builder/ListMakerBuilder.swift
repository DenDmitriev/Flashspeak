//
//  ListMakerBuilder.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 21.04.2023.
//

import UIKit

struct ListMakerBuilder {
    static func build(list: List, router: ListMakerEvent) -> (UIViewController & ListMakerViewInput) {
        let presenter = ListMakerPresenter(list: list, router: router)
        let tokenFieldDelegate = ListMakerTokenFieldDelegate()
        let collectionDataSource = ListMakerCollectionViewDataSource()
        let collectionDelegate = ListMakerCollectionViewDelegate()
        let collectionDragDelegate = ListMakerDragDelegate()
        let collectionDropDelegate = ListMakerDropDelegate()
        let textDropDelegate = ListMakerTextDropDelegate()
        
        let viewController = ListMakerViewController(
            presenter: presenter,
            tokenFieldDelegate: tokenFieldDelegate,
            collectionDataSource: collectionDataSource,
            collectionDelegate: collectionDelegate,
            collectionDragDelegate: collectionDragDelegate,
            collectionDropDelegate: collectionDropDelegate,
            textDropDelegate: textDropDelegate
        )
        
        presenter.viewInput = viewController
        tokenFieldDelegate.viewController = viewController
        collectionDataSource.viewController = viewController
        collectionDelegate.viewController = viewController
        collectionDragDelegate.viewController = viewController
        collectionDropDelegate.viewController = viewController
        textDropDelegate.viewController = viewController
        
        return viewController
    }
}
