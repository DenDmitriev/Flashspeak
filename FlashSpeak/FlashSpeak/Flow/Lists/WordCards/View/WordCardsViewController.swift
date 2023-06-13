//
//  WordCardsViewController.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 15.04.2023.
//
// swiftlint:disable weak_delegate

import UIKit

class WordCardsViewController: UIViewController {
    
    // MARK: - Properties
    
    var wordCardCellModels = [WordCardCellModel]()
    var style: GradientStyle?
    let presenter: WordCardsViewOutput
    
    // MARK: - Private properties
    
    private let wordCardsCollectionDataSource: WordCardsCollectionDataSource
    private let wordCardsCollectionDelegate: WordCardsCollectionDelegate
    
    // MARK: - Constraction
    
    init(
        title: String,
        style: GradientStyle,
        presenter: WordCardsPresenter,
        wordCardsCollectionDataSource: WordCardsCollectionDataSource,
        wordCardsCollectionDelegate: WordCardsCollectionDelegate
    ) {
        self.presenter = presenter
        self.wordCardsCollectionDelegate = wordCardsCollectionDelegate
        self.wordCardsCollectionDataSource = wordCardsCollectionDataSource
        super.init(nibName: nil, bundle: nil)
        self.title = title
        self.style = style
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var wordCardsView: WordCardsView {
        return self.view as? WordCardsView ?? WordCardsView()
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = WordCardsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        addButtons()
        addActions()
    }
    
    // MARK: - Private functions
    
    private func addActions() {
        wordCardsView.editButton.addTarget(
            self,
            action: #selector(didTapEdit),
            for: .touchUpInside
        )
        wordCardsView.editListPropertiesButton.addTarget(
            self,
            action: #selector(editListDidTap(sender:)),
            for: .touchUpInside
        )
    }
    
    private func configureCollectionView() {
        wordCardsView.collectionView.delegate = wordCardsCollectionDelegate
        wordCardsView.collectionView.dataSource = wordCardsCollectionDataSource
        wordCardsView.collectionView.register(
            WordCardViewCell.self,
            forCellWithReuseIdentifier: WordCardViewCell.identifier
        )
    }
    
    private func addButtons() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            customView: wordCardsView.editListPropertiesButton
        )
    }
    
    // MARK: - Actions
    
    @objc private func editListDidTap(sender: UIButton) {
        didTapEditList()
    }
    
    @objc private func didTapEdit() {
        didTapEditButton()
    }
}

extension WordCardsViewController: WordCardsViewInput {
    
    
    // MARK: - Functions
    
    func didTapEditList() {
        presenter.editList()
    }
    
    func didTapEditButton() {
        presenter.didTapEditButton()
    }
    
    func reloadWordsView() {
        navigationItem.title = presenter.list.title
        style = presenter.list.style
        navigationController?.navigationBar.tintColor = UIColor.color(by: presenter.list.style)
        wordCardsView.collectionView.reloadData()
    }
    
    func didTapWord(indexPath: IndexPath) {
        presenter.showWordCard(index: indexPath.item)
    }
    
    func reloadWordView(by index: Int) {
        let indexPath = IndexPath(item: index, section: .zero)
        wordCardsView.reloadItem(by: indexPath)
    }
    
    func reloadWordView(by index: Int, viewModel: WordCardCellModel) {
        wordCardsView.collectionView.performBatchUpdates {
            wordCardCellModels[index] = viewModel
            wordCardsView.collectionView.reloadItems(at: [IndexPath(item: index, section: .zero)])
        }
    }
    
    func deleteWords(by indexPaths: [IndexPath]) {
        wordCardsView.collectionView.performBatchUpdates {
            indexPaths.forEach { wordCardCellModels.remove(at: $0.item) }
            wordCardsView.collectionView.deleteItems(at: indexPaths)
        }
    }
}

// swiftlint:enable weak_delegate
