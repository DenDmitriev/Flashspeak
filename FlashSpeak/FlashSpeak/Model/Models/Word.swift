//
//  Word.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 16.04.2023.
//

import Foundation

struct Word: Equatable {
    var id: UUID = UUID()
    var source: String
    var translation: String
    var imageURL: URL?
    
    var rightAnswers: Int = 0
    var wrongAnswers: Int = 0
    
    init(wordCD: WordCD) {
        self.id = wordCD.id
        self.source = wordCD.title
        self.translation = wordCD.translation ?? ""
        self.imageURL = wordCD.imageURL
        self.rightAnswers = Int(wordCD.numberOfRightAnswers)
        self.wrongAnswers = Int(wordCD.numberOfWrongAnsewrs)
    }
    
    init(source: String, translation: String) {
        self.source = source
        self.translation = translation
    }
    
    static func ==(lhs: Word, rhs: Word) -> Bool {
        return lhs.id == rhs.id &&
        lhs.source == rhs.source &&
        lhs.translation == rhs.translation &&
        lhs.imageURL == rhs.imageURL &&
        lhs.rightAnswers == rhs.rightAnswers &&
        lhs.wrongAnswers == rhs.wrongAnswers
    }
}
