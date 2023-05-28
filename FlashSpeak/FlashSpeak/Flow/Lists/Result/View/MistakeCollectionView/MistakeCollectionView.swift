//
//  MistakeCollectionView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 28.05.2023.
//
// swiftlint:disable weak_delegate

import UIKit

protocol MistakeCollectionViewProtocol: AnyObject {
    var mistakeViewModels: [WordCellModel] { get set }
}

class MistakeCollectionView: UICollectionView, MistakeCollectionViewProtocol {

    var mistakeViewModels = [WordCellModel]()
    
    private let mistakeCollectionViewDataSource: UICollectionViewDataSource
    private let mistakeCollectionViewDelegate: UICollectionViewDelegate
    
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let mistakeCollectionViewDelegate = MistakeCollectionViewDelegate()
        let mistakeCollectionViewDataSource = MistakeCollectionViewDataSource()
        self.mistakeCollectionViewDataSource = mistakeCollectionViewDataSource
        self.mistakeCollectionViewDelegate = mistakeCollectionViewDelegate
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        mistakeCollectionViewDelegate.view = self
        mistakeCollectionViewDataSource.view = self
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    private func configure() {
        showsHorizontalScrollIndicator = false
        setContentHuggingPriority(.defaultHigh, for: .vertical)
        backgroundColor = .clear
        delegate = mistakeCollectionViewDelegate
        dataSource = mistakeCollectionViewDataSource
        register(WordCell.self, forCellWithReuseIdentifier: WordCell.identifier)
    }
}

// swiftlint:enable weak_delegate
