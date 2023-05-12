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
    
    private let newListPublisher = PassthroughSubject<List, Never>()
    private let newImagePublisher = PassthroughSubject<(String, URL), Never>()
    private let service: NetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Constraction
    
    init(list: List, router: ListMakerEvent, service: NetworkServiceProtocol = NetworkService()) {
        self.list = list
        self.router = router
        self.service = service
        subscribers()
    }
    
    // MARK: - Private Functions
    
    private func subscribers() {
        newListPublisher
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.saveListToCD(self.list)
                    self.viewInput?.spinner(isActive: false)
                    self.router?.didSendEventClosure?(.generate)
                }
            }, receiveValue: { list in
                if list.addImageFlag {
                    guard
                        let sourceLanguage = UserDefaultsHelper.source()
                    else { return }
                    list.words.forEach { word in
                        self.getImages(word: word.source, language: sourceLanguage)
                    }
                } else {
                    self.newImagePublisher.send(completion: .finished)
                }
            })
            .store(in: &cancellables)
        
        newImagePublisher
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.newListPublisher.send(completion: .finished)
                }
            }, receiveValue: { sourceWord, url in
                if let index = self.list.words.firstIndex(where: { $0.source == sourceWord }) {
                    self.list.words[index].imageURL = url
                }
            })
            .store(in: &cancellables)
    }
    
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
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(#function, error.errorDescription)
                default:
                    return
                    // self.newListPublisher.send(completion: .finished)
                }
            }, receiveValue: { [self] translated in
                translated.translatedWord.forEach { word in
                    list.words.append(
                        Word(
                            source: word.sourceWords.text,
                            translation: word.translations.text
                        )
                    )
                }
                self.newListPublisher.send(list)
            })
            .store(in: &cancellables)
    }
    
    private func getImages(word: String, language: Language) {
        guard
            let url = URLConfiguration.shared.imageURL(word: word, language: language)
        else { return }
        service.getImageURL(url: url)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(#function, error.errorDescription)
                default:
                    self.newImagePublisher.send(completion: .finished)
                }
            } receiveValue: { imageResponse in
                guard
                    let result = imageResponse.results.first
                else { return }
                let smallImageURL = result.urls.small
                // let thumbImageURL = urls.thumb
                self.newImagePublisher.send((word, smallImageURL))
            }
            .store(in: &cancellables)
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
    }
}
