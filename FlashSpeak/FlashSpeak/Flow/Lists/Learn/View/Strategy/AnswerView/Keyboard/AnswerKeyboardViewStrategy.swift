//
//  File.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 19.05.2023.
//
// swiftlint: disable weak_delegate

import UIKit

class AnswerKeyboardViewStrategy: AnswerViewStrategy {
    
    /// Section for textFiled and button
    static let numberOfSections = 2
    /// One textFiled and one button
    static let numberOfItemsInSection = 1
    /// Number section for textFiled
    static let textFiledSection = 0
    /// Number section for button
    static let buttonSection = 1

    let textFieldDelegate: UITextFieldDelegate
    
    override init(delegate: AnswerViewControllerDelegate? = nil) {
        self.textFieldDelegate = AnswerTextFieldDelegate()
        super.init(delegate: delegate)
        self.collectionViewDataSource = AnswerKeyboardViewDataSource()
        self.collectionViewDelegate = AnswerKeyboardViewDelegate()
        self.collectionView.register(
            AnswerKeyboardCell.self,
            forCellWithReuseIdentifier: AnswerKeyboardCell.identifier
        )
        self.collectionView.register(
            AnswerButtonCell.self,
            forCellWithReuseIdentifier: AnswerButtonCell.identifier
        )
        self.collectionView.dataSource = collectionViewDataSource
        self.collectionView.delegate = collectionViewDelegate
        (self.collectionViewDataSource as? AnswerKeyboardViewDataSource)?.view = self
        (self.collectionViewDelegate as? AnswerKeyboardViewDelegate)?.view = self
        (self.textFieldDelegate as? AnswerTextFieldDelegate)?.view = self
    }
    
    override func set(answer: Answer) {
        self.answer = answer
        highlight(isRight: nil, index: .zero)
        clearTextFiled()
    }
    
    override func didAnswer(indexPath: IndexPath? = nil) {
        guard let answer = answer else { return }
        delegate?.didAnswer(answer)
    }
    
    override func action(_ action: AnswerViewStrategy.Action) {
        switch action {
        case .dissmisKeyboard:
            guard let cell = collectionView.cellForItem(
                at: IndexPath(item: .zero, section: AnswerKeyboardViewStrategy.textFiledSection)
            ) as? AnswerKeyboardCell else { return }
            cell.answerTextField.resignFirstResponder()
        }
    }
    
    func answerDidTap() {
        didAnswer()
    }
    
    private func clearTextFiled() {
        guard
            let cell = collectionView.cellForItem(
                at: IndexPath(item: .zero, section: .zero)
            ) as? AnswerKeyboardCell
        else { return }
        cell.answerTextField.text = nil
    }
}

// swiftlint: enable weak_delegate
