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
    var listID: UUID
    
    // MARK: - Constraction
    
    init(wordsCount: Int, listID: UUID) {
        self.learn = Learn(
            startTime: Date.now,
            finishTime: Date.now,
            result: .zero,
            count: wordsCount
        )
        self.listID = listID
    }
    
    // MARK: - Functions
    
    func addResult(answer: Bool) {
        if answer {
            learn.result += 1
        }
    }
    
    func finish() {
        learn.finishTime = Date.now
        saveLearnToCD(learn, for: listID)
    }
    
    // MARK: - Private Functions
    
    private func saveLearnToCD(_ learn: Learn, for listID: UUID) {
        CoreDataManager.instance.createLearn(learn, for: listID)
    }
}
