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
    var style: GradientStyle? { get }
    var presenter: WordCardsViewOutput { get }
    
    func didTabSettingsButton()
    func didTabLearnButton()
    func didTapWord(indexPath: IndexPath)
    func reloadWordsView()
    func reloadWordView(by index: Int)
    func reloadWordView(by index: Int, viewModel: WordCardCellModel)
    func deleteWords(by indexPaths: [IndexPath])
    func setResults(learnings: [Learn], wordsCount: Int)
}

protocol WordCardsViewOutput {
    var list: List { get set }
    var router: WordCardsEvent? { get set }
    
    func didTabSettingsButton()
    func didTapLearnButton()
    func showWordCard(index: Int)
    func subscribe()
    func reloadOriginWord(by wordID: UUID)
    func edit(by indexPath: IndexPath)
    func deleteWords(by indexPaths: [IndexPath])
}

class WordCardsPresenter: NSObject {
    
    enum Origin {
        case coreData, raw
    }
    
    var list: List
    weak var viewInput: (UIViewController & WordCardsViewInput)?
    var router: WordCardsEvent?
    
    // MARK: - Private Functions
    
    @Published private var error: LocalizedError?
    private let fetchedLearnResultsController: NSFetchedResultsController<LearnCD>
    private let listSubject: CurrentValueSubject<List, WordCardsError>
    private let imageURLSubject = PassthroughSubject<Word, WordCardsError>()
    private var store = Set<AnyCancellable>()
    private let networkService = NetworkService()
    private let coreData = CoreDataManager.instance
    private var origin: Origin
    
    // MARK: - Init
    
    init(
        list: List,
        router: WordCardsEvent,
        fetchedLearnResultsController: NSFetchedResultsController<LearnCD>
    ) {
        self.router = router
        self.list = list
        self.fetchedLearnResultsController = fetchedLearnResultsController
        self.listSubject = .init(self.list)
        self.origin = WordCardsPresenter.getOrigin(listID: list.id)
        super.init()
        initFetchedResultsController()
        errorSubscribe()
        imageURLSubscriber()
    }
    
    // MARK: - Private functions
    
    private static func getOrigin(listID: UUID) -> Origin {
        if CoreDataManager.instance.getListObject(by: listID) == nil {
            return .raw
        } else {
            return .coreData
        }
    }
    
    private func setResults(list: List) {
        viewInput?.setResults(
            learnings: list.learns.sorted { $0.startTime > $1.startTime },
            wordsCount: list.words.count
        )
    }
    
    func fetchLearnings() {
        guard
            let listCD = coreData.getListObject(by: list.id)
        else { return }
        let learnings = List(listCD: listCD).learns
        self.list.learns = learnings
        setResults(list: list)
    }
    
    private func syncList(_ list: List) {
        switch self.origin {
        case .coreData:
            if let originlist = self.fetchListOrigin(list) {
                self.list = originlist
            }
        case .raw:
            self.saveListToCD(list)
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
    
    private func loadImageSubscriber(for word: Word, by index: Int) {
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
                self.loadImageSubscriber(for: word, by: index)
            }
            .store(in: &store)
    }
    
    // MARK: CoreData functions
    
    private func initFetchedResultsController() {
        fetchedLearnResultsController.delegate = self
        do {
            try fetchedLearnResultsController.performFetch()
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
    
    private func fetchListOrigin(_ list: List) -> List? {
        if let originlistCD = self.coreData.getListObject(by: list.id) {
            let originList = List(listCD: originlistCD)
            return originList
        } else {
            return nil
        }
    }
}

extension WordCardsPresenter: WordCardsViewOutput {
    
    // MARK: - Functions
    
    func didTabSettingsButton() {
        router?.didSendEventClosure?(.settings)
    }
    
    func didTapLearnButton() {
        router?.didSendEventClosure?(.learn(list: list))
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
                self.syncList(list)
                self.setResults(list: list)
                list.words.enumerated().forEach { index, word in
                    let wordModel = WordCardCellModel.modelFactory(word: word)
                    self.viewInput?.wordCardCellModels.append(wordModel)
                    guard list.addImageFlag else { return }
                    if word.imageURL == nil {
                        self.imageURLSubject.send(word)
                    } else {
                        self.loadImageSubscriber(for: word, by: index)
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
        loadImageSubscriber(for: word, by: index)
    }
    
    func edit(by indexPath: IndexPath) {
        showWordCard(index: indexPath.item)
    }
    
    func deleteWords(by indexPaths: [IndexPath]) {
        viewInput?.deleteWords(by: indexPaths)
        let coreData = CoreDataManager.instance
        let wordToDelete = list.words[indexPaths[0].item]
        coreData.deleteWordObject(by: wordToDelete.id)
    }
}

// MARK: - Fetch Results
extension WordCardsPresenter: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        fetchLearnings()
    }
}
