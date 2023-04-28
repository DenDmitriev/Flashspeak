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
    var tokenCollection: UICollectionView? { get }
    var removeCollection: UICollectionView? { get }
    
    func generateList()
    func hideRemoveArea(isHidden: Bool)
    func updateRemoveArea(isActive: Bool)
    func deleteToken(token: String)
    func deleteToken(indexPaths: [IndexPath])
    func addToken(token: String)
    func spinner(isActive: Bool)
}

protocol ListMakerViewOutput {
    var list: List { get set }
    var router: ListMakerEvent? { get }
    
    func generateList(words: [String])
}

class ListMakerPresenter {
    
    // MARK: - Properties
    
    var list: List
    var router: ListMakerEvent?
    let coreData = CoreDataManager.instance
    
    weak var viewInput: (UIViewController & ListMakerViewInput)?
    
    // MARK: - Private properties
    
    private let newList = PassthroughSubject<List, Never>()
    private let service: NetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Constraction
    
    init(list: List, router: ListMakerEvent, service: NetworkServiceProtocol = NetworkService()) {
        self.list = list
        self.router = router
        self.service = service
        
        newList
            .sink(receiveValue: {
                self.saveListToCD($0)
                self.viewInput?.spinner(isActive: false)
                self.router?.didSendEventClosure?(.generate)
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Private Functions
    
    private func saveListToCD(_ list: List) {
        guard coreData.getListObject(by: list.id) == nil else {
            saveWordsToCD(list.words, listID: list.id)
            return
        }
        
        guard
            let sourceLanguage = UserDefaultsHelper.source(),
            let targetLanguage = UserDefaultsHelper.target(),
            let study = coreData.getStudyObject(source: sourceLanguage, target: targetLanguage)
        else { return }
        
        coreData.createList(list, for: study)
        
//        if let studies = coreData.studies,
//           !studies.isEmpty {
//            coreData.createList(list, for: studies[0])
//        } else {
//            coreData.createStudy(Study(sourceLanguage: .russian, targerLanguage: .english))
//            if let studies = coreData.studies {
//                coreData.createList(list, for: studies[0])
//            }
//        }
        saveWordsToCD(list.words, listID: list.id)
    }
    
    private func saveWordsToCD(_ words: [Word], listID: UUID) {
        guard let listCD = coreData.getListObject(by: listID) else { return }
        var wordsFromCD = [Word]()
        listCD.wordsCD?.forEach {
            guard let wordCD = $0 as? WordCD else { return }
            wordsFromCD.append(Word(wordCD: wordCD))
        }
        let wordsToCreate = words.filter { word in
            !wordsFromCD.contains { $0.source == word.source }
        }
        coreData.createWords(wordsToCreate, for: listCD)
    }
}

extension ListMakerPresenter: ListMakerViewOutput {
    
    // MARK: - Functions
    
    func generateList(words: [String]) {
        guard
            let sourceLanguage = UserDefaultsHelper.source(),
            let targetLanguage = UserDefaultsHelper.target()
        else { return }
        
        viewInput?.spinner(isActive: true)
        if let url = UrlConfiguration.shared.translateUrl(
            words: words,
            targetLang: targetLanguage,
            sourceLang: sourceLanguage
        ) {
            service.translateWords(url: url)
                .receive(on: DispatchQueue.main)
                .sink { error in
                    print(error)
                } receiveValue: { [self] translated in
                    translated.translatedWord.forEach { word in
                        list.words.append(
                            Word(
                                source: word.sourceWords.text,
                                translation: word.translations.text
                            )
                        )
                    }
                    self.newList.send(list)
                }
                .store(in: &cancellables)
        }
    }
}
