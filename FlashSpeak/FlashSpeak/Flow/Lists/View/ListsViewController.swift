//
//  ListsViewController.swift
//  Lingocard
//
//  Created by Denis Dmitriev on 12.04.2023.
//

import UIKit

class ListsViewController: UIViewController {
    
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
        lists = FakeLists.lists
        self.getLists()
    }
    
    @objc private func didTapNewList(sender: UIButton) {
        print(#function)
        didTapNewList()
    }
    
    @objc private func didTapLanguage(sender: UIButton) {
        didTapLanguage()
    }

}

extension ListsViewController: ListsViewInput {
    
    func getLists() {
        presenter.viewGetLists()
    }
    
    func didSelectList(index: Int) {
        let list = lists[index]
        presenter.showWordCards(list: list)
    }
    
    func didTapNewList() {
        presenter.showNewListController()
    }
    
    func didTapLanguage() {
        presenter.showLanguageController()
    }
}
