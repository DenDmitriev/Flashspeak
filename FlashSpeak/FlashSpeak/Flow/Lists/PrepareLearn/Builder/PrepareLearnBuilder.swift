//
//  PrepareLearnBuilder.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 25.05.2023.
//

import UIKit

struct PrepareLearnBuilder {
    static func build(router: PrepareLearnEvent) -> UIViewController & PrepareLearnInput {
        let presenter = PrepareLearnPresenter(router: router)
        
        let viewController = PrepareLearnViewController()
        
        presenter.viewController = viewController
        
        return viewController
    }
}
