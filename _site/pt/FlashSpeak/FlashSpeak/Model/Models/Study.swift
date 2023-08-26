//
//  Study.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 16.04.2023.
//

import Foundation

struct Study {
    var id: UUID = UUID()
    var started: Date
    var sourceLanguage: Language
    var targetLanguage: Language
    var lists: [List]
    
    init(studyCD: StudyCD) {
        self.id = studyCD.id
        self.started = studyCD.startDate
        self.sourceLanguage = Language(rawValue: Int(studyCD.sourceLanguage)) ?? .russian
        self.targetLanguage = Language(rawValue: Int(studyCD.targetLanguage)) ?? .russian
        var lists = [List]()
        studyCD.listsCD?.forEach {
            if let list = $0 as? ListCD {
                let list = List(listCD: list)
                lists.append(list)
            }
        }
        self.lists = lists
    }
    
    init(sourceLanguage: Language, targerLanguage: Language) {
        self.id = UUID()
        self.started = Date.now
        self.sourceLanguage = sourceLanguage
        self.targetLanguage = targerLanguage
        self.lists = []
    }
}
