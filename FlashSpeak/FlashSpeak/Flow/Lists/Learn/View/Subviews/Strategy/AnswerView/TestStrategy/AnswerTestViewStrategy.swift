//
//  AnswerTestViewStrategy.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 19.05.2023.
//

import UIKit

class AnswerTestViewStrategy: AnswerViewStrategy {
    
    /// Section for test answers
    static let numberOfItemInSections = 6
    static let itemPerRow: CGFloat = 2
    static let itemPerColumn: CGFloat = 3
    
    override init(delegate: AnswerViewControllerDelegate? = nil, color: UIColor? = nil) {
        super.init(delegate: delegate)
        self.collectionViewDataSource = AnswerTestViewDataSource()
        self.collectionViewDelegate = AnswerTestViewDelegate()
        self.collectionView.register(
            AnswerWordCell.self,
            forCellWithReuseIdentifier: AnswerWordCell.identifier
        )
        self.collectionView.dataSource = collectionViewDataSource
        self.collectionView.delegate = collectionViewDelegate
        (self.collectionViewDataSource as? AnswerTestViewDataSource)?.view = self
        (self.collectionViewDelegate as? AnswerTestViewDelegate)?.view = self
    }
    
    override func set(answer: Answer) {
        self.answer = answer
        collectionView.reloadData()
    }
    
    override func didAnswer(indexPath: IndexPath?) {
        guard
            let indexPath = indexPath,
            var testAnswer = answer as? TestAnswer
        else { return }
        testAnswer.answer = testAnswer.words[indexPath.item]
        delegate?.didAnswer(testAnswer)
    }
}
