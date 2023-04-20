//
//  WordCardsViewController.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 15.04.2023.
//

import UIKit

class WordCardsViewController: UIViewController {
    
    private let presenter: WordCardsPresenter
    private let wordCardsCollectionDataSource: WordCardsCollectionDataSource
    private let wordCardsCollectionDelegate: WordCardsCollectionDelegate
    
    var words = [Word]()
    var style: GradientStyle?
    
    init(list: List, presenter: WordCardsPresenter, wordCardsCollectionDataSource: WordCardsCollectionDataSource, wordCardsCollectionDelegate: WordCardsCollectionDelegate) {
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
        return self.view as! WordCardsView
    }
    
    override func loadView() {
        super.loadView()
        self.view = WordCardsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        wordCardsView.collectionView.delegate = wordCardsCollectionDelegate
        wordCardsView.collectionView.dataSource = wordCardsCollectionDataSource
        wordCardsView.collectionView.register(WordCardViewCell.self, forCellWithReuseIdentifier: WordCardViewCell.identifier)
    }
}

extension WordCardsViewController: WordCardsViewInput {
    
}
