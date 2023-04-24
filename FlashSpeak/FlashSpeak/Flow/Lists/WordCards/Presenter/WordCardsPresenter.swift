//
//  WordCardsPublisher.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import UIKit

protocol WordCardsViewInput {
    var words: [Word] { get set }
    var style: GradientStyle? { get }
}

protocol WordCardsViewOutput {
    func showWordCard(word: Word)
}

class WordCardsPresenter {
    
    var viewInput: (UIViewController & WordCardsViewInput)?
    
}

extension WordCardsPresenter: WordCardsViewOutput {
    
    func showWordCard(word: Word) {
        print(#function)
    }
}
