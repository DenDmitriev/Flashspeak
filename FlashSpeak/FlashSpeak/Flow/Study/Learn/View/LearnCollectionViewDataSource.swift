//
//  LearnCollectionViewDataSource.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 05.05.2023.
//
// swiftlint:disable line_length

import UIKit

class LearnCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    weak var viewController: (UIViewController & LearnViewInput)?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewController?.answer.words.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnswerCell.identifier, for: indexPath) as? AnswerCell,
            let answer = viewController?.answer.words[indexPath.item]
        else { return UICollectionViewCell() }
        cell.configure(text: answer)
        return cell
    }
}

// swiftlint:enable line_length
