//
//  ProgressView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 31.05.2023.
//
// swiftlint: disable weak_delegate

import UIKit

protocol ProgressViewInput: AnyObject {
    var count: Int { get set }
    
    func setAnswer(isRight: Bool, index: Int)
    func scrollToCenter(by index: Int)
}

class ProgressView: UICollectionView {

    // MARK: - Properties
    var count: Int = .zero
    
    // MARK: - Private properties
    private let collectionDataSource: UICollectionViewDataSource?
    private let collectionDelegate: UICollectionViewDelegate?

    // MARK: - Constraction
    
    init() {
        let collectionDelegate = ProgressViewDelegate()
        let collectionDataSource = ProgressViewDataSource()
        self.collectionDataSource = collectionDataSource
        self.collectionDelegate = collectionDelegate
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        collectionDelegate.view = self
        collectionDataSource.view = self
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        showsHorizontalScrollIndicator = false
        backgroundColor = .clear
        delegate = collectionDelegate
        dataSource = collectionDataSource
        register(ProgressCell.self, forCellWithReuseIdentifier: ProgressCell.identifier)
    }
}

extension ProgressView: ProgressViewInput {
    
    func setAnswer(isRight: Bool, index: Int) {
        let indexPath = IndexPath(item: index, section: .zero)
        guard let cell = cellForItem(at: indexPath) as? ProgressCell else { return }
        cell.isRight = isRight
    }
    
    func scrollToCenter(by index: Int) {
        self.scrollToItem(
            at: IndexPath(item: index, section: .zero),
            at: .centeredHorizontally,
            animated: true
        )
    }
}

// swiftlint: enable weak_delegate
