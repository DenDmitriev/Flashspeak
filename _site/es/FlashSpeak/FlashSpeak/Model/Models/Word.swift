//
//  Word.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 16.04.2023.
//

import Foundation

struct Word: Hashable {
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
    
    func nameForCustomImage() -> String {
        return id.uuidString
    }
    
    func learned() -> Bool {
        return rightAnswers - wrongAnswers > 0 ? true : false
    }
}
