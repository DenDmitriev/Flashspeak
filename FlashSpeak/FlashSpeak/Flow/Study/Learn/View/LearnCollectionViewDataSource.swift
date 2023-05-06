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
    var answerType: LearnSettings.Answer?
    
    enum TestCollection {
        
        /// Test cells section
        static let numberOfSections = 1
    }
    
    enum KeyboardCollection {
        
        /// Number section for textFiled
        static let textFiledSection = 0
        
        /// Number section for button
        static let buttonSection = 1
        
        /// One textFiled and one button
        static let numberOfItemsInSection = 1
        
        /// firsr textField and second button for answer
        static let numberOfSections = 2
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch answerType {
        case .test:
            return TestCollection.numberOfSections
        case .keyboard:
            return KeyboardCollection.numberOfSections
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch answerType {
        case .test:
            guard let testAnswer = viewController?.answer as? TestAnswer else { return .zero }
            return testAnswer.words.count
        case .keyboard:
            return KeyboardCollection.numberOfItemsInSection
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch answerType {
        case .test:
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnswerWordCell.identifier, for: indexPath) as? AnswerWordCell,
                let testAnswer = viewController?.answer as? TestAnswer
            else { return UICollectionViewCell() }
            let text = testAnswer.words[indexPath.item]
            cell.configure(text: text)
            return cell
            
        case .keyboard:
            if indexPath.section == KeyboardCollection.textFiledSection {
                guard
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnswerKeyboardCell.identifier, for: indexPath) as? AnswerKeyboardCell
                else { return UICollectionViewCell() }
                cell.answerTextField.delegate = viewController?.answerTextFieldDelegate
                return cell
            } else {
                guard
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnswerButtonCell.identifier, for: indexPath) as? AnswerButtonCell
                else { return UICollectionViewCell() }
                cell.button.addTarget(self, action: #selector(keyboardDidAnswer), for: .touchUpInside)
                return cell
            }
            
        default:
            return UICollectionViewCell()
        }
    }
    
    @objc func keyboardDidAnswer() {
        viewController?.keyboardDidAnswer()
    }
}

// swiftlint:enable line_length
