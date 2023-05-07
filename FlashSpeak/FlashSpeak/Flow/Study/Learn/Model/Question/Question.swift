//
//  Question.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 04.05.2023.
//

import UIKit

protocol Question {
    /// Learn word
    var question: String { get }
    var image: UIImage? { get set }
}
