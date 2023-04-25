//
//  ListsViewController.swift
//  Lingocard
//
//  Created by Denis Dmitriev on 12.04.2023.
//

import UIKit

extension ListsViewController: ListsEvent {
    enum Event {
        case newList, changeLanguage, lookList(list: List)
    }
}

class ListsViewController: UIViewController {
    
    var didSendEventClosure: ((Event) -> Void)? // Положить это в презентер
    
    private let presenter: ListsPresenter
    private let listsCollectionDataSource: UICollectionViewDataSource
    private let listsCollectionDelegate: UICollectionViewDelegate
    
    init(
        presenter: ListsPresenter,
        listsCollectionDataSource: UICollectionViewDataSource,
        listsCollectionDelegate: UICollectionViewDelegate
    ) {
        self.presenter = presenter
        self.listsCollectionDataSource = listsCollectionDataSource
        self.listsCollectionDelegate = listsCollectionDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var listsView: ListsView {
        return view as? ListsView ?? ListsView()
    }
    
    var lists = [List]() // Отправить в презентер
    // var listsViewModel = [ListsViewModel]()
    
    override func loadView() {
        super.loadView()
        view = ListsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureButton()
        configureLanguageButton()
        createCustomBarButtonItem()
        configureCollectionView()
    }
    
    private func configureButton() {
        listsView.newListButton.addTarget(
            self,
            action: #selector(didTapNewList(sender:)),
            for: .touchUpInside
        )
    }
    
    private func configureLanguageButton() {
        listsView.changeLanguageButton.addTarget(
            self,
            action: #selector(didTapLanguage(sender:)),
            for: .touchUpInside
        )
    }
    
    private func createCustomBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: listsView.changeLanguageButton)
    }
      
    private func configureCollectionView() {
        listsView.collectionView.delegate = listsCollectionDelegate
        listsView.collectionView.dataSource = listsCollectionDataSource
        listsView.collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.identifier)
        
//        lists = FakeLists.lists
        presenter.getLists()
    }
    
    // MARK: - Actions
    
    @objc private func didTapNewList(sender: UIButton) {
        didTapNewList()
    }
    
    @objc private func didTapLanguage(sender: UIButton) {
        didTapLanguage()
        // present.didTapLanguage()
    }
    
}

extension ListsViewController: ListsViewInput {
    
    func didTapLanguage() {
        print(#function)
        self.didSendEventClosure?(.changeLanguage)
    }
    
    func didTapNewList() {
        print(#function)
        self.didSendEventClosure?(.newList)
    }
    
    func didSelectList(index: Int) {
        print(#function)
        let list = lists[index]
        self.didSendEventClosure?(.lookList(list: list))
    }
    
    func reloadListsView() {
        listsView.collectionView.reloadData()
    }
}
