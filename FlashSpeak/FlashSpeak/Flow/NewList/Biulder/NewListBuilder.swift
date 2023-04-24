//
//  NewListBuilder.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import UIKit

struct NewListBuilder {
    
    static func build() -> UIViewController {
        let presenter = NewListPresenter()
        let colorCollectionDelegate = NewListColorCollectionDelegate()
        let colorCollectionDataSource = NewListColorCollectionDataSource()
        let gestureRecognizerDelegate = NewListGestureRecognizerDelegate()
        let textFieldDelegate = NewLisTextFieldDelegate()
        
        let viewController = NewListViewController(
            presenter: presenter,
            newListColorCollectionDelegate: colorCollectionDelegate,
            newListColorCollectionDataSource: colorCollectionDataSource,
            gestureRecognizerDelegate: gestureRecognizerDelegate,
            textFieldDelegate: textFieldDelegate
        )
        
        presenter.viewInput = viewController
        colorCollectionDelegate.viewInput = viewController
        
        return viewController
    }
}
