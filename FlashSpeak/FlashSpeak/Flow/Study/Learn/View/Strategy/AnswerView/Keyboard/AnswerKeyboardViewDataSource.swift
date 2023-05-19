//
//  AnswerKeyboardViewDataSource.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 19.05.2023.
//
// swiftlint:disable line_length

import UIKit

class AnswerKeyboardViewDataSource: NSObject, UICollectionViewDataSource {
    
    weak var view: AnswerKeyboardViewStrategy?
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return AnswerKeyboardViewStrategy.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AnswerKeyboardViewStrategy.numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case AnswerKeyboardViewStrategy.textFiledSection:
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnswerKeyboardCell.identifier, for: indexPath) as? AnswerKeyboardCell
            else { return UICollectionViewCell() }
            cell.answerTextField.delegate = view?.textFieldDelegate
            return cell
        case AnswerKeyboardViewStrategy.buttonSection:
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnswerButtonCell.identifier, for: indexPath) as? AnswerButtonCell
            else { return UICollectionViewCell() }
            cell.button.addTarget(self, action: #selector(buttonDidTap(sender:)), for: .touchUpInside)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    @objc func buttonDidTap(sender: UIButton) {
        view?.answerDidTap()
    }
}

// swiftlint:enable line_length
