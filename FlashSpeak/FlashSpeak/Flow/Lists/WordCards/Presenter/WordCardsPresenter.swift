//
//  WordCardsPublisher.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import UIKit
import Combine
import CoreData

protocol WordCardsViewInput {
    var wordCardCellModels: [WordCardCellModel] { get set }
    var searchingWordCardCellModels: [WordCardCellModel] { get set }
    var style: GradientStyle? { get }
    var presenter: WordCardsViewOutput { get }
    var isSearching: Bool { get set }
    var imageFlag: Bool { get set }
    
    func didTapEditButton()
    func didTapWord(indexPath: IndexPath)
    func didTapEditList()
    func reloadWordsView()
    func reloadWordView(by index: Int)
    func reloadWordView(by index: Int, viewModel: WordCardCellModel)
    func reloadWordCardsCollection()
    func deleteWords(by indexPaths: [IndexPath])
}

protocol WordCardsViewOutput {
    var list: List { get set }
    var router: WordCardsEvent? { get set }
    
    func didTapEditButton()
    func showWordCard(index: Int)
    func subscribe()
    func reloadOriginWord(by wordID: UUID)
    func edit(by indexPath: IndexPath)
    func deleteWords(by indexPaths: [IndexPath])
    func editList()
}

class WordCardsPresenter: NSObject {
    
    enum Origin {
        case coreData, new
    }
    
    var list: List
    weak var viewInput: (UIViewController & WordCardsViewInput)?
    var router: WordCardsEvent?
    
    // MARK: - Private Functions
    
    @Published private var error: LocalizedError?
    private let fetchedListResultsController: NSFetchedResultsController<ListCD>
    private let listSubject = PassthroughSubject<List, WordCardsError>()
    private let imageURLSubject = PassthroughSubject<Word, WordCardsError>()
    private var store = Set<AnyCancellable>()
    private let networkService = NetworkService()
    private let coreData = CoreDataManager.instance
    private var origin: Origin
    
    // MARK: - Init
    
    init(
        list: List,
        router: WordCardsEvent,
        fetchedListResultsController: NSFetchedResultsController<ListCD>
    ) {
        self.router = router
        self.list = list
        self.fetchedListResultsController = fetchedListResultsController
        self.origin = WordCardsPresenter.getOrigin(listID: list.id)
        super.init()
        initFetchedResultsController()
        errorSubscribe()
        imageURLSubscriber()
        subscribe()
        syncList(list)
    }
    
    // MARK: - Private functions
    
    private func syncList(_ list: List) {
        switch self.origin {
        case .coreData:
            self.updateWordsInListCD(list)
        case .new:
            self.saveListToCD(list)
        }
        updateListFromCD()
    }
    
    private static func getOrigin(listID: UUID) -> Origin {
        if CoreDataManager.instance.getListObject(by: listID) == nil {
            return .new
        } else {
            return .coreData
        }
    }
    
    // MARK: Subscribers
    
    private func errorSubscribe() {
        self.$error
            .receive(on: RunLoop.main)
            .sink { error in
                guard let error = error else { return }
                self.router?.didSendEventClosure?(.error(error: error))
            }
            .store(in: &store)
    }
    
    private func loadImageSubscriber(for word: Word) {
        guard
            let index = viewInput?.wordCardCellModels.firstIndex(where: { $0.source == word.source })
        else { return }
        Just(word.imageURL)
            .flatMap({ imageURL -> AnyPublisher<UIImage?, Never> in
                guard
                    let url = imageURL
                else {
                    return Just(UIImage(named: "placeholder"))
                        .eraseToAnyPublisher()
                }
                return ImageLoader.shared.loadImage(from: url)
            })
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.viewInput?.reloadWordView(by: index)
                }
            } receiveValue: { image in
                self.viewInput?.wordCardCellModels[index].image = image
            }
            .store(in: &store)
    }
    
    private func imageURLSubscriber() {
        imageURLSubject
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print(completion)
                case .failure(let error):
                    self.error = error
                }
            } receiveValue: { word in
                self.getImageURL(word: word.source)
            }
            .store(in: &store)
    }
    
    // MARK: Network functions
    
    private func getImageURL(word: String) {
        guard
            let sourceLanguage = UserDefaultsHelper.source(),
            let url = URLConfiguration.shared.imageURL(word: word, language: sourceLanguage)
        else { return }
        networkService.getImageURL(url: url)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.error = WordCardsError.imageURL(error: error)
                case .finished:
                    return
                }
            } receiveValue: { imageResponse in
                guard
                    let result = imageResponse.results.first,
                    let index = self.list.words.firstIndex(where: { $0.source == word })
                else { return }
                let smallImageURL = result.urls.small
                self.list.words[index].imageURL = smallImageURL
                let word = self.list.words[index]
                self.updateWordInCD(word)
                self.loadImageSubscriber(for: word)
            }
            .store(in: &store)
    }
    
    // MARK: CoreData functions
    
    private func initFetchedResultsController() {
        fetchedListResultsController.delegate = self
        do {
            try fetchedListResultsController.performFetch()
        } catch let error {
            print("Something went wrong at performFetch cycle. Error: \(error.localizedDescription)")
        }
    }

    private func saveListToCD(_ list: List) {
        guard coreData.getListObject(by: list.id) == nil else {
            saveWordsToCD(list.words, listID: list.id)
            return
        }
        guard
            let sourceLanguage = UserDefaultsHelper.source(),
            let targetLanguage = UserDefaultsHelper.target(),
            let study = coreData.studies?.first(where: {
                $0.sourceLanguage == sourceLanguage.rawValue &&
                $0.targetLanguage == targetLanguage.rawValue
            })
        else { return }
        coreData.createList(list, for: study)
        saveWordsToCD(list.words, listID: list.id)
    }
    
    private func updateWordsInListCD(_ list: List) {
        guard
            let listCD = coreData.getListObject(by: list.id),
            let wordsFromCD = listCD.wordsCD?.compactMap({ $0 as? WordCD }).map({ Word(wordCD: $0) }),
            wordsFromCD.sorted(by: { $0.source > $1.source }) !=
                list.words.sorted(by: { $0.source > $1.source })
        else { return }
        
        let missingWords = wordsFromCD.filter({ wordFromCD in
            !list.words.contains { $0.id == wordFromCD.id }
        })
        missingWords.forEach({ coreData.deleteWordObject(by: $0.id) })
        
        let lostWords = wordsFromCD.filter({ wordFromCD in
            list.words.contains(where: { $0.id == wordFromCD.id })
        })
        let newWords = list.words.filter({ word in
            !lostWords.contains(where: { $0.id == word.id })
        })
        coreData.createWords(newWords, for: listCD)
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
    
    private func updateWordInCD(_ word: Word) {
        if let error = coreData.updateWord(word, by: word.id).map({ CardError.save(error: $0) }) {
            self.error = WordCardsError.save(error: error)
        }
    }
    
    private func updateListFromCD() {
        if let listCD = coreData.getListObject(by: list.id) {
            list = List(listCD: listCD)
            listSubject.send(list)
        }
    }
}

extension WordCardsPresenter: WordCardsViewOutput {
    
    // MARK: - Functions
    
    func didTapEditButton() {
        router?.didSendEventClosure?(.edit)
    }
    
    func showWordCard(index: Int) {
        let word = list.words[index]
        router?.didSendEventClosure?(.word(word: word))
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
                self.viewInput?.imageFlag = list.addImageFlag
                self.viewInput?.wordCardCellModels = []
                list.words.forEach { word in
                    let wordModel = WordCardCellModel.modelFactory(word: word)
                    self.viewInput?.wordCardCellModels.append(wordModel)
                    guard list.addImageFlag else { return }
                    if word.imageURL == nil {
                        self.imageURLSubject.send(word)
                    } else {
                        self.loadImageSubscriber(for: word)
                    }
                }
                self.viewInput?.reloadWordsView()
            })
            .store(in: &store)
    }
    
    func reloadOriginWord(by wordID: UUID) {
        guard
            let wordCD = coreData.getWordObject(by: wordID),
            let index = list.words.firstIndex(where: { $0.id == wordID }),
            var wordCardCellModel = viewInput?.wordCardCellModels[index]
        else { return }
        let word = Word(wordCD: wordCD)
        list.words[index] = word
        wordCardCellModel.translation = word.translation
        viewInput?.reloadWordView(by: index, viewModel: wordCardCellModel)
        loadImageSubscriber(for: word)
    }
    
    func edit(by indexPath: IndexPath) {
        showWordCard(index: indexPath.item)
    }
    
    func deleteWords(by indexPaths: [IndexPath]) {
        viewInput?.deleteWords(by: indexPaths)
        let wordToDelete = list.words[indexPaths[0].item]
        coreData.deleteWordObject(by: wordToDelete.id)
    }
    
    func editList() {
        router?.didSendEventClosure?(.editListProperties(list: list))
    }
}

// MARK: - Fetch Results
extension WordCardsPresenter: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateListFromCD()
        viewInput?.reloadWordsView()
    }
}
