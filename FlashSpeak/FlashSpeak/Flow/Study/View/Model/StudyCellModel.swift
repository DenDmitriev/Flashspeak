//
//  LearnCellModel.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 27.04.2023.
//

import Foundation

struct StudyCellModel {
    let title: String
    let learnCount: Int
    let lastResult: Int?
    let wordsCount: Int
    let time: String?
    let style: GradientStyle
    
    static func modelFactory(
        list: List,
        lastResult: Int,
        time: String
    ) -> StudyCellModel {
        return StudyCellModel(
            title: list.title,
            learnCount: list.learns.count,
            lastResult: lastResult,
            wordsCount: list.words.count,
            time: time,
            style: list.style
        )
    }
}
