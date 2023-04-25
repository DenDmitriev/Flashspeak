//
//  LanguageBuilder.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import UIKit

struct LanguageBuilder {
    
    static func build() -> (UIViewController & LanguageViewInput & LanguageEvent) {
        let presenter = LanguagePresenter()
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
