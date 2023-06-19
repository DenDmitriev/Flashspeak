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
    var style: GradientStyle? { get set }
    
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
    func showAlert(source: UIView?)
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
    
    private func getTranslate(words: [String], source: Language, target: Language) {
        guard
            let url = URLConfiguration.shared.translateURLGoogle(
                words: words,
                targetLang: target,
                sourceLang: source
            )
        else { return }
        networkService.translateWordsWithGoogle(url: url)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    let description = error.errorDescription ?? error.localizedDescription
                    self.error = ListMakerError.loadTransalte(description: description)
                case .finished:
                    self.complete()
                }
            }, receiveValue: { [self] response in
                response.data.translations.enumerated().forEach { index, word in
                    let word = Word(source: words[index].lowercased(), translation: word.translatedText)
                    list.words.append(word)
                }
            })
            .store(in: &cancellables)
    }
    
    /// Sync list words for edited token sequence
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
        if !rawWords.isEmpty {
            getTranslate(words: rawWords, source: sourceLanguage, target: targetLanguage)
        } else {
            complete()
        }
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
        viewController.modalPresentationStyle = .automatic
        self.viewController?.present(viewController, animated: true)
    }
    
    func showAlert(source: UIView? = nil) {
        let listWords = list.words.map({ $0.source }).sorted(by: { $0 < $1 })
        let tokenWords = viewController?.tokens.sorted(by: { $0 < $1 })
        guard listWords != tokenWords else {
            self.viewController?.navigationController?.popViewController(animated: true)
            return
        }
        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet
        )
        let exit = UIAlertAction(
            title: NSLocalizedString("Exit without saving", comment: "Title"),
            style: .destructive
        ) { (_: UIAlertAction) -> Void in
            self.viewController?.navigationController?.popViewController(animated: true)
        }
        let save = UIAlertAction(
            title: NSLocalizedString("Go back", comment: "Title"),
            style: .default,
            handler: nil
        )

        alert.addAction(exit)
        alert.addAction(save)
        alert.modalPresentationStyle = .automatic
        self.viewController?.present(alert, animated: true)
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
