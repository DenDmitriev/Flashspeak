//
//  QuestionWordView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 19.05.2023.
//

import UIKit

struct QuestionWordViewStrategy: QuestionViewStrategy {
    var view: UIView = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .titleBold1
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = Grid.factor50
        label.isUserInteractionEnabled = true
        return label
    }()
    
    func set(question: Question) {
        (view as? UILabel)?.text = question.question
    }
}
