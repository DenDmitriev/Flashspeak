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
    
    init(listCD: ListCD) {
        self.id = listCD.id
        self.title = listCD.title
        self.style = GradientStyle(rawValue: Int(listCD.style)) ?? .grey
        self.created = listCD.creationDate
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
         created: Date) {
        self.title = title
        self.words = words
        self.style = style
        self.created = created
    }
}
