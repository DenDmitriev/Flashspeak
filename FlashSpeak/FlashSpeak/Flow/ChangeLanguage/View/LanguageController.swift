//
//  ChangeLanguageController.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 17.04.2023.
//

import UIKit

class LanguageController: UIViewController {
    
    private var presenter: LanguagePresenter
    private var languageTableDataSource: UITableViewDataSource
    private var languageTableDelegate: UITableViewDelegate
    private let gestureRecognizerDelegate: UIGestureRecognizerDelegate
    
    var study: Study?
    
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
        return self.view as! LanguageView
    }
    
    override func loadView() {
        super.loadView()
        self.view = LanguageView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureGesture()
        // Do any additional setup after loading the view.
    }
    
    private func configureTableView() {
        self.languageView.tableView.dataSource = languageTableDataSource
        self.languageView.tableView.delegate = languageTableDelegate
        self.getStudy()
    }
    
    private func configureGesture() {
        let tapBackground = UITapGestureRecognizer(target: self, action: #selector(didTapBackroundView(sender:)))
        tapBackground.delegate = gestureRecognizerDelegate
        self.languageView.addGestureRecognizer(tapBackground)
    }
    
    //MARK: - Actions
    
    @objc private func didTapBackroundView(sender: UIView) {
        dissmisView()
    }
}

extension LanguageController: LanguageViewInput {
    
    func dissmisView() {
        presenter.close()
    }
    
    func getStudy() {
        presenter.viewGetStudy()
    }
    
    func didSelectItem(index: Int) {
        presenter.changeStudyLanguage(language: Language.allCases[index])
    }
}
