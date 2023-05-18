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
    func spinner(isActive: Bool, title: String?)
    func clearField()
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
    
    private let listSubject = PassthroughSubject<List, Never>()
    private let imageSubject = PassthroughSubject<(String, URL), Never>()
    private let imageQueueSubject = PassthroughSubject<[Word], Never>()
    private let service: NetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    @Published private var error: ListMakerError?
    
    // MARK: - Constraction
    
    init(list: List, router: ListMakerEvent, service: NetworkServiceProtocol = NetworkService()) {
        self.list = list
        self.router = router
        self.service = service
        listSubscriber()
        errorSubscribe()
    }
    
    // MARK: - Private Functions
    
    private func listSubscriber() {
        listSubject
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.saveListToCD(self.list)
                    self.viewInput?.spinner(isActive: false, title: nil)
                    self.router?.didSendEventClosure?(.generate)
                }
            }, receiveValue: { list in
                if list.addImageFlag {
                    guard
                        let sourceLanguage = UserDefaultsHelper.source()
                    else { return }
                    self.imageSubscriber()
                    list.words.forEach { word in
                        self.getImageURL(word: word.source, language: sourceLanguage)
                    }
                } else {
                    self.imageSubject.send(completion: .finished)
                }
            })
            .store(in: &cancellables)
    }
    
    private func imageSubscriber() {
        imageSubject
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.listSubject.send(completion: .finished)
                }
            }, receiveValue: { sourceWord, url in
                if let index = self.list.words.firstIndex(where: { $0.source == sourceWord }) {
                    self.list.words[index].imageURL = url
                }
                if self.list.words.compactMap({ $0.imageURL }).count == self.list.words.count {
                    self.imageSubject.send(completion: .finished)
                }
            })
            .store(in: &cancellables)

    }
    
    private func errorSubscribe() {
        self.$error
            .receive(on: RunLoop.main)
            .sink { error in
                guard let error = error else { return }
                self.router?.didSendEventClosure?(.error(error: error))
            }
            .store(in: &cancellables)
    }
    
    // MARK: Network functions
    
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
                    self.error = ListMakerError.loadTransalte(error: error)
                default:
                    return
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
                listSubject.send(list)
            })
            .store(in: &cancellables)
    }
    
    private func getImageURL(word: String, language: Language) {
        guard
            let url = URLConfiguration.shared.imageURL(word: word, language: language)
        else { return }
        service.getImageURL(url: url)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.error = ListMakerError.imageURL(error: error)
                default:
                    return
                }
            } receiveValue: { imageResponse in
                guard
                    let result = imageResponse.results.first
                else { return }
                let smallImageURL = result.urls.small
                self.imageSubject.send((word, smallImageURL))
            }
            .store(in: &cancellables)
    }
    
    // MARK: CoreData functions
    
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
}

extension ListMakerPresenter: ListMakerViewOutput {
    
    // MARK: - Functions
    
    func generateList(words: [String]) {
        guard
            let sourceLanguage = UserDefaultsHelper.source(),
            let targetLanguage = UserDefaultsHelper.target()
        else { return }
        
        let title = NSLocalizedString("Translating", comment: "Title")
        viewInput?.spinner(isActive: true, title: title)
        
        getTranslateWords(words: words, source: sourceLanguage, target: targetLanguage)
    }
}
