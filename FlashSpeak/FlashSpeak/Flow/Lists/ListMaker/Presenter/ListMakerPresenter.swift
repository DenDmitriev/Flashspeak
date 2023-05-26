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
    
    func subscribe()
    func createList(words: [String])
    func showHint()
    func complete()
}

class ListMakerPresenter {
    
    // MARK: - Properties
    
    var list: List
    var router: ListMakerEvent?
    weak var viewController: (UIViewController & ListMakerViewInput)?
    
    // MARK: - Private properties
    
    private let networkService: NetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private let listSubject: CurrentValueSubject<List, ListMakerError>
    @Published private var error: ListMakerError?
    
    // MARK: - Constraction
    
    init(list: List, router: ListMakerEvent, service: NetworkServiceProtocol = NetworkService()) {
        self.list = list
        self.listSubject = .init(self.list)
        self.router = router
        self.networkService = service
        errorSubscribe()
    }
    
    // MARK: - Private Functions
    
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
        networkService.translateWords(url: url)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.error = ListMakerError.loadTransalte(error: error)
                case .finished:
                    self.complete()
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
            })
            .store(in: &cancellables)
    }
    
    /// Sync  list words for edited token sequence
    private func syncListWithTokens(tokens words: [String]) {
        let exsistWords = words.filter { word in
            if list.words.contains(where: { $0.source == word }) {
                return true
            } else {
                return false
            }
        }
        
        var removeableWords = [Word]()
        list.words.forEach { word in
            if !exsistWords.contains(where: { $0 == word.source }) {
                removeableWords.append(word)
            }
        }
        removeableWords.forEach { word in
            list.words.removeAll(where: { $0.id == word.id })
            CoreDataManager.instance.deleteWordObject(by: word.id)
        }
        
    }
    
    /// Remove from token sequence already exist words in list
    private func filterExisted(tokens words: [String]) -> [String] {
        return words.filter { word in
            if list.words.contains(where: { $0.source == word }) {
                return false
            } else {
                return true
            }
        }
    }
}

extension ListMakerPresenter: ListMakerViewOutput {
    
    // MARK: - Functions
    
    func createList(words: [String]) {
        guard
            let sourceLanguage = UserDefaultsHelper.source(),
            let targetLanguage = UserDefaultsHelper.target()
        else { return }
        
        let title = NSLocalizedString("Translating", comment: "Title")
        viewController?.spinner(isActive: true, title: title)
        
        let rawWords = filterExisted(tokens: words)
        syncListWithTokens(tokens: words)
        
        getTranslateWords(words: rawWords, source: sourceLanguage, target: targetLanguage)
    }
    
    func showHint() {
        var router = HintRouter()
        router.didSendEventClosure = { [weak self] event in
            switch event {
            case .close:
                self?.viewController?.dismiss(animated: true)
            }
        }
        let viewController = HintBuilder.build(router: router)
        viewController.modalPresentationStyle = .popover
        self.viewController?.present(viewController, animated: true)
    }
    
    func complete() {
        viewController?.spinner(isActive: false, title: nil)
        router?.didSendEventClosure?(.generate(list: list))
    }
    
    func subscribe() {
        listSubject
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print(completion)
                case .failure(let error):
                    self.error = error
                }
            }, receiveValue: { list in
                list.words.map { $0.source }.forEach { self.viewController?.addToken(token: $0) }
            })
            .store(in: &cancellables)
    }
}
