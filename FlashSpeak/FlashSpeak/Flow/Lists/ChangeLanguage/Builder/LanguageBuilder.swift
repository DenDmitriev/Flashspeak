//
//  LanguageBuilder.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import UIKit

struct LanguageBuilder {
    
    static func build(router: LanguageEvent, language: Language) -> (UIViewController & LanguageViewInput) {
        let presenter = LanguagePresenter(router: router, language: language)
        let tableDataSource = LanguageTableDataSource()
        let tableDelegate = LanguageTableDelegate()
        let gestureRecognizerDelegate = LanguageGestureRecognizerDelegate()
        
        let viewInput = LanguageController(
            presenter: presenter,
            languageTableDataSource: tableDataSource,
            languageTableDelegate: tableDelegate,
            gestureRecognizerDelegate: gestureRecognizerDelegate
        )
        
        presenter.viewInput = viewInput
        tableDelegate.viewInput = viewInput
        tableDataSource.viewInput = viewInput
        
        return viewInput
    }
}
