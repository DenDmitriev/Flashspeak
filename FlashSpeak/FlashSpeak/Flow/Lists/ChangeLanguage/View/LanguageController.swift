//
//  ChangeLanguageController.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 17.04.2023.
//
// swiftlint:disable weak_delegate

import UIKit

class LanguageController: UIViewController {
    
    // MARK: - Properties
    
    var languages: [Language] {
        Language.allCases
    }
    var language: Language?
    
    // MARK: - Private properties
    
    private var presenter: LanguagePresenter
    private let languageTableDataSource: UITableViewDataSource
    private let languageTableDelegate: UITableViewDelegate
    private let gestureRecognizerDelegate: UIGestureRecognizerDelegate
    
    // MARK: - Constraction
    
    init(
        presenter: LanguagePresenter,
        languageTableDataSource: UITableViewDataSource,
        languageTableDelegate: UITableViewDelegate,
        gestureRecognizerDelegate: UIGestureRecognizerDelegate
    ) {
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
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = LanguageView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.subscribe()
        presenter.viewGetStudy()
        configureTableView()
        configureGesture()
    }
    
    // MARK: - Private functions
    
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
        didTabBackground()
    }
}

extension LanguageController: LanguageViewInput {
    
    // MARK: - Functions
    
    func didTabBackground() {
        presenter.viewDidTapBackground()
    }
    
    func didSelectItem(indexPath: IndexPath) {
        presenter.viewDidSelectedLanguage(language: languages[indexPath.item])
    }
}

// swiftlint:enable weak_delegate
