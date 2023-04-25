//
//  WordCardsViewController.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 15.04.2023.
//

import UIKit

class WordCardsViewController: UIViewController {
    
    // MARK: - Properties
    
    var words = [Word]()
    var style: GradientStyle?
    
    // MARK: - Private properties
    
    private let presenter: WordCardsPresenter
    private let wordCardsCollectionDataSource: WordCardsCollectionDataSource
    private let wordCardsCollectionDelegate: WordCardsCollectionDelegate
    
    // MARK: - Constraction
    
    init(
        list: List,
        presenter: WordCardsPresenter,
        wordCardsCollectionDataSource: WordCardsCollectionDataSource,
        wordCardsCollectionDelegate: WordCardsCollectionDelegate
    ) {
        self.presenter = presenter
        self.wordCardsCollectionDelegate = wordCardsCollectionDelegate
        self.wordCardsCollectionDataSource = wordCardsCollectionDataSource
        super.init(nibName: nil, bundle: nil)
        self.words = list.words
        self.title = list.title
        self.style = list.style
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
    }
    
    // MARK: - Functions
    
    // MARK: - Private functions
    
    private func configureCollectionView() {
        wordCardsView.collectionView.delegate = wordCardsCollectionDelegate
        wordCardsView.collectionView.dataSource = wordCardsCollectionDataSource
        wordCardsView.collectionView.register(
            WordCardViewCell.self,
            forCellWithReuseIdentifier: WordCardViewCell.identifier
        )
    }
}

extension WordCardsViewController: WordCardsViewInput {
    
}
