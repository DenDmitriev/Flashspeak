//
//  ListsViewController.swift
//  Lingocard
//
//  Created by Denis Dmitriev on 12.04.2023.
//

import UIKit

class ListsViewController: UIViewController {
    
    // MARK: - Properties
    
    var listCellModels = [ListCellModel]()
    
    // MARK: - Private properties
    
    private var presenter: ListsViewOutput
    private let listsCollectionDataSource: UICollectionViewDataSource
    private let listsCollectionDelegate: UICollectionViewDelegate
    
    // MARK: - Constraction
    
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
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        view = ListsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.subscribe()
        configureButton()
        configureLanguageButton()
        createCustomBarButtonItem()
        configureCollectionView()
    }
    
    // MARK: - Private functions
    
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
    
    // MARK: - Functions
    
    func didTapLanguage() {
        presenter.changeLanguage()
    }
    
    func didTapNewList() {
        presenter.newList()
    }
    
    func didSelectList(indexPath: IndexPath) {
        presenter.lookList(at: indexPath)
    }
    
    func reloadListsView() {
        listsView.collectionView.reloadData()
    }
}
