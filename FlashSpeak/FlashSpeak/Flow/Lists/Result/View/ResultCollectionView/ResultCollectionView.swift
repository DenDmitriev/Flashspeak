//
//  ResultCollectionView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 28.05.2023.
//
// swiftlint:disable weak_delegate

import UIKit

protocol ResultCollectionViewProtocol: AnyObject {
    var resultViewModels: [ResultViewModel] { get set }
}

class ResultCollectionView: UICollectionView, ResultCollectionViewProtocol {

    var resultViewModels = [ResultViewModel]()
    
    private let resultCollectionViewDataSource: UICollectionViewDataSource
    private let resultCollectionViewDelegate: UICollectionViewDelegate
    
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let resultCollectionViewDelegate = ResultsCollectionViewDelegate()
        let resultCollectionViewDataSource = ResultsCollectionViewDataSource()
        self.resultCollectionViewDelegate = resultCollectionViewDelegate
        self.resultCollectionViewDataSource = resultCollectionViewDataSource
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        resultCollectionViewDelegate.view = self
        resultCollectionViewDataSource.view = self
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
        delegate = resultCollectionViewDelegate
        dataSource = resultCollectionViewDataSource
        register(ResultCell.self, forCellWithReuseIdentifier: ResultCell.identifier)
    }

}

// swiftlint:enable weak_delegate
