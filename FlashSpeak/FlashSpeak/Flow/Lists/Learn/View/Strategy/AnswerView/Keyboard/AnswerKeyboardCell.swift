//
//  AnswerKeyboardCell.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 06.05.2023.
//

import UIKit

class AnswerKeyboardCell: UICollectionViewCell, AnswerCell {
    
    // MARK: - Propetes
    
    static let identifier = "Answer word cell"
    var isRight: Bool? {
        didSet {
            switch isRight {
            case true:
                UIView.animate(withDuration: 0.2) {
                    self.backgroundColor = .systemGreen.withAlphaComponent(Grid.factor50)
                }
            case false:
                UIView.animate(withDuration: 0.2) {
                    self.backgroundColor = .systemRed.withAlphaComponent(Grid.factor50)
                }
            default:
                backgroundColor = .fiveBackgroundColor
            }
        }
    }
    
    // MARK: - Subviews
    
    let answerTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = NSLocalizedString("Write the answer", comment: "Placeholder")
        textField.font = .titleBold2
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
        backgroundColor = .fiveBackgroundColor
    }
    
    // MARK: - UI
    
    private func configureView() {
        backgroundColor = .fiveBackgroundColor
        layer.masksToBounds = true
        layer.cornerRadius = Grid.cr12
    }
    
    private func configureSubviews() {
        contentView.addSubview(answerTextField)
    }
    
    // MARK: - Methods
    
    // MARK: - Constraints
    // swiftlint:disable line_length
    private func addConstraints() {
        NSLayoutConstraint.activate([
            
            answerTextField.topAnchor.constraint(equalTo: contentView.topAnchor),
            answerTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Grid.pt16),
            answerTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Grid.pt16),
            answerTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    // swiftlint:enable line_length
}
