//
//  QuestionViewStrategy.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 19.05.2023.
//

import UIKit

protocol QuestionViewStrategy {
    var view: UIView { get }
    
    func set(question: Question)
}
