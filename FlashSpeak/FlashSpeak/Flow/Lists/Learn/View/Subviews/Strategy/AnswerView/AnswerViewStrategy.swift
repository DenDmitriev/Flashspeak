//
//  AnswerViewStrategy.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 19.05.2023.
//
// swiftlint: disable weak_delegate

import UIKit

protocol AnswerViewControllerDelegate: AnyObject {
    func didAnswer(_ answer: Answer)
}

protocol AnswerViewStrategyProtocol {
    var answer: Answer? { get set }
    var collectionView: UICollectionView { get }
    var collectionViewDelegate: UICollectionViewDelegate? { get set }
    var collectionViewDataSource: UICollectionViewDataSource? { get set }
    var delegate: AnswerViewControllerDelegate? { get set }
    
    func set(answer: Answer)
    func didAnswer(indexPath: IndexPath?)
    func highlight(isRight: Bool?, index: Int)
    func action(_ action: AnswerViewStrategy.Action)
}

class AnswerViewStrategy: AnswerViewStrategyProtocol {
    
    enum Action {
        case dissmisKeyboard
    }
    
    /// Size for cells
    static let height = Grid.pt48
    static let separator = Grid.pt8
    
    var answer: Answer?
    var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: flowLayout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    var collectionViewDelegate: UICollectionViewDelegate?
    var collectionViewDataSource: UICollectionViewDataSource?
    var delegate: AnswerViewControllerDelegate?
    
    init(delegate: AnswerViewControllerDelegate?) {
        self.delegate = delegate
    }
    
    func set(answer: Answer) {
        // overwrite in strategy view
    }
    
    func didAnswer(indexPath: IndexPath?) {
        // overwrite in strategy view
    }
    
    func highlight(isRight: Bool?, index: Int) {
        let indexPath = IndexPath(item: index, section: .zero)
        guard
            var cell = collectionView.cellForItem(at: indexPath) as? AnswerCell
        else { return }
        cell.isRight = isRight
    }
    
    func action(_ action: Action) {}
}

// swiftlint: enable weak_delegate
