//
//  WordModel.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 26.04.2023.
//

import UIKit

struct WordCardCellModel {
    let source: String
    let translation: String
    var image: UIImage?
    
    static func modelFactory(word: Word) -> WordCardCellModel {
        var image: UIImage?
        if let imageURL = word.imageURL {
            let cache = ImageCache()
            print(imageURL)
            image = cache[imageURL]
        }
        
        return WordCardCellModel(
            source: word.source,
            translation: word.translation,
            image: image
        )
    }
}
