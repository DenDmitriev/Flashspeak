//
//  ListMakerPresenter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 21.04.2023.
//

import UIKit
import Combine

protocol ListMakerViewInput {
    var tokens: [String] { get set }
    func hideRemoveArea(isHidden: Bool)
    func updateRemoveArea(isActive: Bool)
    func deleteToken(token: String)
    func deleteToken(indexPaths: [IndexPath])
    func addToken(token: String)
    var tokenCollection: UICollectionView? { get }
    var removeCollection: UICollectionView? { get }
}

protocol ListMakerViewOutput {
    var list: List { get set }
    func generateList(words: [String])
}

class ListMakerPresenter {
    
    var list: List
    let coreData = CoreDataManager.instance
    
    var viewController: (UIViewController & ListMakerViewInput)?
    
    init(list: List) {
        self.list = list
    }
}

extension ListMakerPresenter: ListMakerViewOutput {
    
    
    func generateList(words: [String]) {
        words.forEach {
            let word = Word(source: $0, translation: "")
            list.words.append(word)
        }
        if !words.isEmpty {
            saveListToCD(list)
        }
    }
    
    private func saveListToCD(_ list: List) {
        guard coreData.getListObject(by: list.id) == nil else {
            saveWordsToCD(list.words, listID: list.id)
            return
        }
        if let studies = coreData.studies,
           !studies.isEmpty {
            coreData.createList(list, for: studies[0])
        } else {
            coreData.createStudy(Study(sourceLanguage: .russian, targerLanguage: .english))
            if let studies = coreData.studies {
                coreData.createList(list, for: studies[0])
            }
        }
        saveWordsToCD(list.words, listID: list.id)
    }
    
    private func saveWordsToCD(_ words: [Word], listID: UUID) {
        guard let listCD = coreData.getListObject(by: listID) else { return }
        var wordsFromCD = [Word]()
        listCD.wordsCD?.forEach {
            guard let wordCD = $0 as? WordCD else { return }
            wordsFromCD.append(Word(wordCD: wordCD))
        }
        var wordsToCreate = words.filter { word in
            !wordsFromCD.contains { $0.source == word.source }
        }
        coreData.createWords(wordsToCreate, for: listCD)
    }
}
