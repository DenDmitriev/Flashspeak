//
//  MockLictsViewController.swift
//  FlashSpeakTests
//
//  Created by Denis Dmitriev on 29.04.2023.
//

import UIKit
@testable import FlashSpeak

class MockLictsViewController: UIViewController & ListsViewInput {
    
    var listCellModels = [ListCellModel]()
    var presenter: ListsViewOutput?
    
    init(
        presenter: ListsViewOutput
    ) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didSelectList(indexPath: IndexPath) {
        presenter?.editList(at: indexPath)
    }
    
    func didTapLanguage() {
        presenter?.changeLanguage()
    }
    
    func didTapNewList() {
        presenter?.newList()
    }
    
    func reloadListsView() {
        // reload collection view
    }
    
    func configureLanguageButton(language: FlashSpeak.Language) {
        presenter?.changeLanguage()
    }
}
