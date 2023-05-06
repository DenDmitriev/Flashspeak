//
//  AnswerKeyboardCell.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 06.05.2023.
//

import UIKit

class AnswerKeyboardCell: UICollectionViewCell {
    
    // MARK: - Propetes
    
    static let identifier = "Answer word cell"
    var isRight: Bool?
    
    // MARK: - Subviews
    
    let answerTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = NSLocalizedString("Напишите ответ", comment: "Placeholder")
        textField.font = .title1
        textField.textAlignment = .center
        return textField
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureSubviews()
        addConstraints()
    }
    
    // MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        isSelected = false
        isRight = nil
        backgroundColor = .backgroundLightGray
    }
    
    // MARK: - UI
    
    private func configureView() {
        backgroundColor = .backgroundLightGray
        layer.masksToBounds = true
        layer.cornerRadius = Grid.cr16
    }
    
    private func configureSubviews() {
        contentView.addSubview(answerTextField)
    }
    
    // MARK: - Methods
    
    // MARK: - Constraints
    // swiftlint:disable line_length
    private func addConstraints() {
        NSLayoutConstraint.activate([
            
            answerTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Grid.pt16),
            answerTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Grid.pt16),
            answerTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Grid.pt16),
            answerTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Grid.pt16)
        ])
    }
    // swiftlint:enable line_length
}
