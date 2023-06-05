//
//  QuestionImageView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 19.05.2023.
//

import UIKit

struct QuestionImageViewStrategy: QuestionViewStrategy {
    var view: UIView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = Grid.cr12
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    func set(question: Question) {
        var image = question.image
        let cornerRadius = (question.image?.size.width ?? view.frame.width) / view.frame.width * Grid.cr12
        image = image?.roundedImage(cornerRadius: cornerRadius)
        (view as? UIImageView)?.image = question.image
    }
}
