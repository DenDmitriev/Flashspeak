//
//  AnswerViewDataSource.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 19.05.2023.
//
// swiftlint:disable line_length

import UIKit

class AnswerTestViewDataSource: NSObject, UICollectionViewDataSource {
    
    weak var view: AnswerTestViewStrategy?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AnswerTestViewStrategy.numberOfItemInSections
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnswerWordCell.identifier, for: indexPath) as? AnswerWordCell,
            let testAnswer = view?.answer as? TestAnswer,
            testAnswer.words.count >= AnswerTestViewStrategy.numberOfItemInSections
        else { return UICollectionViewCell() }
        let text = testAnswer.words[indexPath.item]
        cell.configure(text: text)
        return cell
    }
}

// swiftlint:enable line_length
