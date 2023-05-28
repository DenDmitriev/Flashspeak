//
//  ResultBuilder.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 07.05.2023.
//
// swiftlint: disable line_length

import UIKit

struct ResultBuilder {
    
    static func build(router: ResultEvent, list: List, mistakes: [Word]) -> (UIViewController & ResultViewInput) {
        
        let presenter = ResultPresenter(router: router, list: list, mistakes: mistakes)
        
        let viewController = ResultViewController(
            presenter: presenter
        )
        
        presenter.viewController = viewController
        
        return viewController
    }
}

// swiftlint: enable line_length
