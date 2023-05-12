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
    func highlightTokenField(isActive: Bool)
    func highlightRemoveArea(isActive: Bool)
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
    
    private func getTranslateWords(words: [String], source: Language, target: Language) {
        guard
            let url = URLConfiguration.shared.translateURL(
                words: words,
                targetLang: target,
                sourceLang: source
            )
        else { return }
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
    
    private func getImages(words: [String], language: Language) {
        words.forEach { word in
            guard
                let url = URLConfiguration.shared.imageURL(word: word, language: language)
            else { return }
            service.getImageURL(url: url)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        print(#function, error.errorDescription)
                    default:
                        print(#function, completion)
                    }
                } receiveValue: { urlImage in
                    print(urlImage)
                }
                .store(in: &cancellables)

        }
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
        
        getTranslateWords(words: words, source: sourceLanguage, target: targetLanguage)
        
//        getImages(words: words, language: sourceLanguage)
    }
}
