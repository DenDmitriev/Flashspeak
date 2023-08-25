//
//  LearnBuilder.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 04.05.2023.
//

import UIKit

struct LearnBuilder {
    static func build(
        router: LearnEvent,
        list: List
    ) -> UIViewController & LearnViewInput {
        
        let presenter = LearnPresenter(router: router, list: list)
        
        let viewController = LearnViewController(
            presenter: presenter,
            answersCount: list.words.count
        )
        
        presenter.viewController = viewController
        
        return viewController
    }
}
