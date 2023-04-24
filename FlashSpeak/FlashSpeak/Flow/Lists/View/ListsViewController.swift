//
//  ListsViewController.swift
//  Lingocard
//
//  Created by Denis Dmitriev on 12.04.2023.
//

import UIKit

class ListsViewController: UIViewController {
    
    var didSendEventClosure: ((ListsViewController.Event) -> Void)?
    
    private let presenter: ListsPresenter
    private let listsCollectionDataSource: UICollectionViewDataSource
    private let listsCollectionDelegate: UICollectionViewDelegate
    
    init(presenter: ListsPresenter, listsCollectionDataSource: UICollectionViewDataSource, listsCollectionDelegate: UICollectionViewDelegate) {
        self.presenter = presenter
        self.listsCollectionDataSource = listsCollectionDataSource
        self.listsCollectionDelegate = listsCollectionDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var listsView: ListsView {
        return self.view as! ListsView
    }
    
    var lists = [List]()
    
    override func loadView() {
        super.loadView()
        self.view = ListsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureButton()
        configureLanguageButton()
        createCustomBarButtonItem()
        configureCollectionView()
    }
    
    private func configureButton() {
        listsView.newListButton.addTarget(self, action: #selector(didTapNewList(sender:)), for: .touchUpInside)
    }
    
    private func configureLanguageButton() {
        listsView.changeLanguageButton.addTarget(self, action: #selector(didTapLanguage(sender:)), for: .touchUpInside)
    }
    
    private func createCustomBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: listsView.changeLanguageButton)
    }
      
    private func configureCollectionView() {
        listsView.collectionView.delegate = listsCollectionDelegate
        listsView.collectionView.dataSource = listsCollectionDataSource
        listsView.collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.identifier)
        
        //Fake data
//        lists = FakeLists.lists
        presenter.getLists()
    }
    
    //MARK: - Actions
    
    @objc private func didTapNewList(sender: UIButton) {
        didTapNewList()
    }
    
    @objc private func didTapLanguage(sender: UIButton) {
        didTapLanguage()
    }
    
}

extension ListsViewController {
    enum Event {
        case newList, changeLanguage, lookList(list: List)
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
