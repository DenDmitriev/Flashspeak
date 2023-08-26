//
//  LearnQuestion.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 09.06.2023.
//

import Foundation

enum LearnQuestion {
    case word, image, wordImage
    
    static func adapter(word: LearnWord.Word, image: LearnImage.Image) -> Self {
        if word == .word,
           image == .image {
            return .wordImage
        } else if word == .word,
                  image == .noImage {
            return .word
        } else if word == .noWord,
                  image == .image {
            return .image
        } else {
            return .wordImage
        }
    }
}
