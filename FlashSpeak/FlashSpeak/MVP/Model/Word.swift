//
//  Word.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 16.04.2023.
//

import Foundation

struct Word {
    var source: String
    var translation: String
    var imageURL: URL?
    
    var rightAnswers: Int = 0
    var wrongAnswers: Int = 0
}
