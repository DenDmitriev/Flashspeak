//
//  ListCellModel.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 26.04.2023.
//

import Foundation

struct ListCellModel {
    let title: String
    let words: [String]
    let style: GradientStyle
    
    static func modelFactory(from model: List) -> ListCellModel {
        return ListCellModel(
            title: model.title,
            words: model.words.map({ $0.source }),
            style: model.style
        )
    }
}
