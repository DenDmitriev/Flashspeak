//
//  HintBuilder.swift
//  FlashSpeak
//
//  Created by Оксана Каменчук on 22.05.2023.
//

import UIKit

struct HintBuilder {
    
    static func build(
        router: HintEvent,
        title: String? = nil,
        paragraphOne: String? = nil
    ) -> (UIViewController & HintViewInput) {
        let presenter = HintPresenter(router: router)
        let gestureRecognizerDelegate = HintGestureRecognizerDelegate()
        
        let viewInput = HintController(
            presenter: presenter,
            gestureRecognizerDelegate: gestureRecognizerDelegate
        )
        presenter.viewInput = viewInput
        
        return viewInput
    }
}
