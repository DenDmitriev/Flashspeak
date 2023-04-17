//
//  List.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 13.04.2023.
//

import Foundation

struct List {
    var id: UUID = UUID()
    var title: String
    var words: [Word]
    var style: GradientStyle
    var created: Date
    var addImageFlag: Bool
    
    init(listCD: ListCD) {
        self.id = listCD.id
        self.title = listCD.title
        self.style = GradientStyle(rawValue: Int(listCD.style)) ?? .grey
        self.created = listCD.creationDate
        self.addImageFlag = listCD.addImageFlag
        var words = [Word]()
        listCD.wordsCD?.forEach {
            if let word = $0 as? WordCD {
                let word = Word(wordCD: word)
                words.append(word)
            }
        }
        self.words = words
    }
    
    init(title: String,
         words: [Word],
         style: GradientStyle,
         created: Date,
         addImageFlag: Bool) {
        self.title = title
        self.words = words
        self.style = style
        self.created = created
        self.addImageFlag = addImageFlag
    }
}
