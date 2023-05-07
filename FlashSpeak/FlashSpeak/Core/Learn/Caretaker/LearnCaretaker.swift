//
//  LearnCaretaker.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 04.05.2023.
//

import Foundation

class LearnCaretaker {
    
    // MARK: - Propetes
    
    var learn: Learn
    
    // MARK: - Constraction
    
    init(wordsCount: Int) {
        self.learn = Learn(
            startTime: Date.now,
            finishTime: Date.now,
            result: .zero,
            count: wordsCount
        )
    }
    
    // MARK: - Functions
    
    func addResult(answer: Bool) {
        if answer {
            learn.result += 1
        }
    }
    
    func finish() {
        learn.finishTime = Date.now
        save()
    }
    
    // MARK: - Private Functions
    
    private func save() {
        // save result to CoreData
    }
}
