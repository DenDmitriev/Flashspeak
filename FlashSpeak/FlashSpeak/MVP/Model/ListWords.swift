//
//  ListWordsFake.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 13.04.2023.
//

import Foundation

struct ListWords {
    var title: String
    
    var words: [String]
    var translates: [String]?
    
    var sourceLang: Language
    var targetLang: Language
    
    var  style: GradientStyle
    
    var dictinary: [String: String] {
        guard let translates = translates else { return [:] }
        return Dictionary(uniqueKeysWithValues: words.enumerated().map({ ($1, translates[$0]) }))
    }
    
    ///Get translation if it exists
    func translation(word: String) -> String {
        dictinary[word] ?? "N/A"
    }
}
