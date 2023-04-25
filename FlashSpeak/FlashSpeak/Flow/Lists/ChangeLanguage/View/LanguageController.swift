//
//  ChangeLanguageController.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 17.04.2023.
//

import UIKit

extension LanguageController: LanguageEvent {
    enum Event {
        case change(language: Language)
        case close
    }
}

class LanguageController: UIViewController {
    
    var didSendEventClosure: ((Event) -> Void)?
    
    var study: Study?
    var languages: [Language] {
        Language.allCases
    }
    
    var changeLanguage: ((Language) -> Void)?
    var close: (() -> Void)?
    
    private var presenter: LanguagePresenter
    private var languageTableDataSource: UITableViewDataSource
    private var languageTableDelegate: UITableViewDelegate
    private let gestureRecognizerDelegate: UIGestureRecognizerDelegate
    
    init(presenter: LanguagePresenter, languageTableDataSource: UITableViewDataSource, languageTableDelegate: UITableViewDelegate, gestureRecognizerDelegate: UIGestureRecognizerDelegate) {
        self.presenter = presenter
        self.languageTableDataSource = languageTableDataSource
        self.languageTableDelegate = languageTableDelegate
        self.gestureRecognizerDelegate = gestureRecognizerDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var languageView: LanguageView {
        return self.view as? LanguageView ?? LanguageView()
    }
    
    override func loadView() {
        super.loadView()
        self.view = LanguageView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewGetStudy()
        configureTableView()
        configureGesture()
    }
    
    private func configureTableView() {
        self.languageView.tableView.dataSource = languageTableDataSource
        self.languageView.tableView.delegate = languageTableDelegate
    }
    
    private func configureGesture() {
        let tapBackground = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapBackroundView(sender:))
        )
        tapBackground.delegate = gestureRecognizerDelegate
        self.languageView.addGestureRecognizer(tapBackground)
    }
    
    // MARK: - Actions
    
    @objc private func didTapBackroundView(sender: UIView) {
        presenter.viewDidTapBackground()
    }
}

extension LanguageController: LanguageViewInput {
    
    func didSelectItem(indexPath: IndexPath) {
        presenter.viewDidSelectedLanguage(language: languages[indexPath.item])
    }
}
