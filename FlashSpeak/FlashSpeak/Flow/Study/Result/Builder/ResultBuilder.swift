//
//  ResultBuilder.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 07.05.2023.
//

import UIKit

struct ResultBuilder {
    
    static func build(router: ResultEvent, learn: Learn) -> (UIViewController & ResultViewInput) {
        
        let presenter = ResultPresenter(router: router, learn: learn)
        let gestureRecognizerDelegate = ResultGestureRecognizerDelegate()
        
        let viewController = ResultViewController(
            presenter: presenter,
            gestureRecognizerDelegate: gestureRecognizerDelegate
        )
        
        presenter.viewController = viewController
        
        return viewController
    }
}
