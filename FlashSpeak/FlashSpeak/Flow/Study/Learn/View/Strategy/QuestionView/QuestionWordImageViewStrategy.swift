//
//  QuestionWordImageView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 19.05.2023.
//

import UIKit

class QuestionWordImageViewStrategy: QuestionViewStrategy {
    lazy var view: UIView = {
        let stackView = UIStackView(arrangedSubviews: [
            questionImageView,
            questionLabel
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = Grid.pt8
        stackView.axis = .vertical
        stackView.layoutMargins = UIEdgeInsets(
            top: Grid.pt8,
            left: Grid.pt8,
            bottom: Grid.pt8,
            right: Grid.pt8
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.isUserInteractionEnabled = true
        return stackView
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .titleBold1
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = Grid.factor50
        return label
    }()
    
    private let questionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    func set(question: Question) {
        questionLabel.text = question.question
        questionImageView.image = question.image?.roundedImage(cornerRadius: Grid.cr12)
    }
}
