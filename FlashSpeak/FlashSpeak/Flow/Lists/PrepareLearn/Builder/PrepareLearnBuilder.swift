//
//  PrepareLearnBuilder.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 25.05.2023.
//

import UIKit

struct PrepareLearnBuilder {
    static func build(router: PrepareLearnEvent, list: List) -> UIViewController & PrepareLearnInput {
        let presenter = PrepareLearnPresenter(router: router, list: list)
        
        let viewController = PrepareLearnViewController(
            presenter: presenter
        )
        
        presenter.viewController = viewController
        
        return viewController
    }
}
