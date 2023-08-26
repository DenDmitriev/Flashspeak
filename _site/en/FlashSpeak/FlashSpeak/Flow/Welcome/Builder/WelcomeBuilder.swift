//
//  WelcomeBuilder.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 28.04.2023.
//

import UIKit

struct WelcomeBuilder {
    static func build(router: WelcomeEvent) -> UIViewController & WelcomeViewInput {
        let presenter = WelcomePresenter(router: router)
        let viewController = WelcomeViewController(presenter: presenter)
        presenter.viewController = viewController
        return viewController
    }
}
