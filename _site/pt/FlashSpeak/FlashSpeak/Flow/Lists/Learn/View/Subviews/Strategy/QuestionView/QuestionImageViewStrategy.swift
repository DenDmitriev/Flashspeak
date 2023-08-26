//
//  QuestionImageView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 19.05.2023.
//

import UIKit

class QuestionImageViewStrategy: QuestionViewStrategy {
    lazy var view: UIView = {
        let stackView = UIStackView(arrangedSubviews: [
            questionImageView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = Grid.pt8
        stackView.axis = .vertical
        stackView.isUserInteractionEnabled = true
        return stackView
    }()
    
    private let questionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = Grid.cr12
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    func set(question: Question) {
        var image = question.image
        let cornerRadius = (question.image?.size.width ?? view.frame.width) / view.frame.width * Grid.cr12
        image = image?.roundedImage(cornerRadius: cornerRadius)
        questionImageView.image = image
    }
}
