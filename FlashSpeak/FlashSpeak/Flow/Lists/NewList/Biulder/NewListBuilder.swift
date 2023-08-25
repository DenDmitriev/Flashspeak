//
//  NewListBuilder.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import UIKit

struct NewListBuilder {
    
    static func build(router: NewListEvent, list: List? = nil) -> (UIViewController & NewListViewInput) {
        let presenter = NewListPresenter(router: router, list: list)
        let colorCollectionDelegate = NewListColorCollectionDelegate()
        let colorCollectionDataSource = NewListColorCollectionDataSource()
        let gestureRecognizerDelegate = NewListGestureRecognizerDelegate()
        let textFieldDelegate = NewLisTextFieldDelegate()
        let viewModel: ListViewModel = .modelFactory(list: list)
        
        let viewController = NewListViewController(
            presenter: presenter,
            viewModel: viewModel,
            newListColorCollectionDelegate: colorCollectionDelegate,
            newListColorCollectionDataSource: colorCollectionDataSource,
            gestureRecognizerDelegate: gestureRecognizerDelegate,
            textFieldDelegate: textFieldDelegate
        )
        
        presenter.viewInput = viewController
        colorCollectionDelegate.viewInput = viewController
        colorCollectionDataSource.viewInput = viewController
        
        return viewController
    }
}
