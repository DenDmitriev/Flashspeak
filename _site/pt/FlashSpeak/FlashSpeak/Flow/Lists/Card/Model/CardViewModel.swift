//
//  CardViewModel.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 15.05.2023.
//

import UIKit

struct CardViewModel {
    let source: String
    var translation: String
    var images: [UIImage]
    
    static func modelFactory(word: Word) -> CardViewModel {
        return CardViewModel(
            source: word.source,
            translation: word.translation,
            images: [UIImage]()
        )
    }
}
