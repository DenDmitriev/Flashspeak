//
//  LearnSettingsManager.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 09.06.2023.
//

import Foundation

protocol LearnSettingsManagerDelegate: AnyObject {
    func forceChange(setting: any LearnSettingProtocol)
}

class LearnSettingsManager {
    
    weak var delegate: LearnSettingsManagerDelegate?
    
    var settings = [LearnSettings: [any LearnSettingProtocol]]()
    var imageFlag: Bool
    
    var timer: LearnTimer.Timer {
        LearnTimer.fromUserDefaults()
    }
    
    var sound: LearnSpeaker.Speaker {
        LearnSpeaker.fromUserDefaults()
    }
    
    var language: LearnLanguage.Language {
        LearnLanguage.fromUserDefaults()
    }
    
    var answer: LearnAnswer.Answer {
        LearnAnswer.fromUserDefaults()
    }
    
    var word: LearnWord.Word {
        LearnWord.fromUserDefaults()
    }
    
    var image: LearnImage.Image {
        LearnImage.fromUserDefaults()
    }
    
    var questionAdapter: LearnQuestion {
        if imageFlag {
            return LearnQuestion.adapter(word: word, image: image)
        } else {
            return LearnQuestion.word
        }
    }
    
    init(wordsCount: Int? = nil, imageFlag: Bool) {
        self.imageFlag = imageFlag
        LearnSettings.allCases.forEach { key in
            let settings: [any LearnSettingProtocol]
            switch key {
            case .mode:
                settings = [LearnTimer(delegate: self), LearnLanguage(delegate: self)]
            case .question:
                settings = [
                    LearnWord(delegate: self),
                    LearnImage(delegate: self, isHidden: !imageFlag),
                    LearnSpeaker(delegate: self)
                ]
            case .answer:
                settings = [LearnAnswer(delegate: self)]
            }
            self.settings[key] = settings
        }
    }
    
    func settings(_ index: Int) -> [any LearnSettingProtocol] {
        if let key = LearnSettings(rawValue: index) {
            return settings[key] ?? []
        } else {
            return []
        }
    }
    
    func count() -> Int {
        return LearnSettings.allCases.count
    }
    
    func countInSection(_ index: Int) -> Int {
        return settings(index).count
    }
    
    func title(_ index: Int) -> String {
        return LearnSettings(rawValue: index)?.title ?? ""
    }
    
    func indexForLanguage() -> Int {
        return settings[.mode]?.firstIndex(where: { $0.title == LearnLanguage(delegate: nil).title }) ?? .zero
    }
    
    func indexForTimer() -> Int {
        return settings[.mode]?.firstIndex(where: { $0.title == LearnTimer(delegate: nil).title }) ?? .zero
    }
}

extension LearnSettingsManager: LearnSettingsDelegate {
    
}
