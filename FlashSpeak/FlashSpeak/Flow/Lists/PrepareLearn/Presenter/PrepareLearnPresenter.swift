//
//  PrepareLearnPresenter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 25.05.2023.
//

import UIKit
import Combine
import CoreData

protocol PrepareLearnInput {
    func configureView(title: String, wordsCount: Int, words: [String])
    func didTapEditCards()
    func didTapStatistic()
    func didTapSettingsButton()
    func didTapLearnButton()
}

protocol PrepareLearnOutput {
    var list: List { get }
    
    func subscribe()
    func didTapLearnButton()
    func didTapStatistic()
    func didTapEditWordsButton()
    func didTapEditCardsButton()
    func showCards()
    func didTapSettingsButon()
}

class PrepareLearnPresenter: NSObject {
    
    // MARK: - Properties
    
    var list: List
    weak var viewController: (UIViewController & PrepareLearnInput)?
    
    // MARK: - Private properties
    
    @Published private var error: LocalizedError?
    
    private let router: PrepareLearnEvent?
    private let listSubject: CurrentValueSubject<List, WordCardsError>
    private var store = Set<AnyCancellable>()
    private let fetchedListResultsController: NSFetchedResultsController<ListCD>
    private let coreData = CoreDataManager.instance
    
    // MARK: - Constraction
    
    init(
        router: PrepareLearnEvent,
        list: List,
        fetchedListResultsController: NSFetchedResultsController<ListCD>
    ) {
        self.router = router
        self.list = list
        self.listSubject = .init(self.list)
        self.fetchedListResultsController = fetchedListResultsController
        super.init()
        initFetchedResultsController()
    }
    
    // MARK: - Private functions
    
    private func configureView(list: List) {
        let words = list.words.map({ $0.source })
        viewController?.configureView(title: list.title, wordsCount: list.words.count, words: words)
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
    
    private func updateListFromCD() {
        if let listCD = coreData.getListObject(by: list.id) {
            list = List(listCD: listCD)
            listSubject.send(list)
        }
    }
}

// MARK: - Functions
extension PrepareLearnPresenter: PrepareLearnOutput {
    
    func didTapLearnButton() {
        router?.didSendEventClosure?(.learn(list: list))
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
                self.configureView(list: list)
            })
            .store(in: &store)
    }
    
    func didTapStatistic() {
        router?.didSendEventClosure?(.showStatistic(list: list))
    }
    
    func showCards() {
        router?.didSendEventClosure?(.showCards(list: list))
    }
    
    func didTapEditCardsButton() {
        router?.didSendEventClosure?(.editCards(list: list))
    }
    
    func didTapEditWordsButton() {
        router?.didSendEventClosure?(.editWords(list: list))
    }
    
    func didTapSettingsButon() {
        router?.didSendEventClosure?(.showSettings)
    }
}

// MARK: - Fetch Results
extension PrepareLearnPresenter: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateListFromCD()
        viewController?.navigationItem.title = list.title
    }
}
