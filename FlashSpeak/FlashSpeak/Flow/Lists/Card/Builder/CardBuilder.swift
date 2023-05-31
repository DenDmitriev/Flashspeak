//
//  CardBuilder.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 15.05.2023.
//

import UIKit

struct CardBuilder {
    static func build(word: Word, style: GradientStyle, router: CardEvent) -> UIViewController & CardViewInput {
        
        let presenter = CardPresenter(word: word, style: style, router: router)
        
        let viewController = CardViewController(presenter: presenter)
        
        presenter.viewController = viewController
        
        return viewController
    }
}
