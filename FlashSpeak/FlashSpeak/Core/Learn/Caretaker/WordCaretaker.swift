//
//  Caretaker.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 04.05.2023.
//

import Foundation

class WordCaretaker {
    
    // MARK: - Propetes
    
    // MARK: - Constraction
    
    // MARK: - Functions
    
    func addResult(answer: Bool, word: Word) {
        var word = word
        if answer {
            word.rightAnswers += 1
        } else {
            word.wrongAnswers += 1
        }
        update(word: word)
    }
    
    func finish() {
        
    }
    
    // MARK: - Private Functions
    
    private func update(word: Word) {
        // update word in CoreData
    }

}
