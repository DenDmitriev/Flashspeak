//
//  AddNewWordBuilder.swift
//  FlashSpeak
//
//  Created by Anastasia Losikova on 28.05.2023.
//

import UIKit

struct AddNewWordBuilder {
    
    static func build(router: AddNewWordEvent, list: List) -> AddNewWordViewController {
        let presenter = AddNewWordPresenter(router: router, list: list)
        
        let viewController = AddNewWordViewController(presenter: presenter, style: list.style)
        presenter.controllerDelegate = viewController
        return viewController
    }
}
