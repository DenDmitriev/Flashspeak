//
//  ListsPresenter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 18.04.2023.
//

import UIKit
import CoreData
import Combine

protocol ListsViewInput {
    var listCellModels: [ListCellModel] { get set }
    
    func didSelectList(indexPath: IndexPath)
    func didTapLanguage()
    func didTapNewList()
    func reloadListsView()
    func configureLanguageButton(language: Language)
}

protocol ListsViewOutput {
    var lists: [List] { get set }
    var router: ListsEvent? { get set }
    
    func subscribe()
    func getStudyLists()
    func newList()
    func changeLanguage()
    func lookList(at indexPath: IndexPath)
}

class ListsPresenter: NSObject, ObservableObject {
    
    @Published var lists = [List]()
    weak var viewController: (UIViewController & ListsViewInput)?
    var router: ListsEvent?
    private let fetchedListsResultController: NSFetchedResultsController<ListCD>
    private var store = Set<AnyCancellable>()
    
    init(
        fetchedListsResultController: NSFetchedResultsController<ListCD>,
        router: ListsEvent
    ) {
        self.fetchedListsResultController = fetchedListsResultController
        self.router = router
        super.init()
        initFetchedResultsController()
        updateListsView()
    }
    
    // MARK: - Private functions
    
    private func updateListsView() {
        getStudyLists()
        viewController?.reloadListsView()
    }
    
    private func initFetchedResultsController() {
        fetchedListsResultController.delegate = self
        do {
            try fetchedListsResultController.performFetch()
        } catch let error {
            print("Something went wrong at performFetch cycle. Error: \(error.localizedDescription)")
        }
    }
}

extension ListsPresenter: ListsViewOutput {
    
    // MARK: - Functions
    
    func subscribe() {
        self.$lists
            .receive(on: RunLoop.main)
            .sink { lists in
                let listCellModels = lists.map({ ListCellModel.modelFactory(from: $0) })
                self.viewController?.listCellModels = listCellModels
                self.viewController?.reloadListsView()
            }
            .store(in: &store)
    }
    
    func getStudyLists() {
        // Get study languages
        guard
            let sourceLanguage = UserDefaultsHelper.source(),
            let targetLanguage = UserDefaultsHelper.target()
        else { return }
        
        // Update language button
        viewController?.configureLanguageButton(language: targetLanguage)
        
        // Get lists by study
        var lists = [List]()
        let coreData = CoreDataManager.instance
        
        guard
            let studyCD = coreData.getStudyObject(source: sourceLanguage, target: targetLanguage),
            let listsCD = studyCD.listsCD
        else { return }
        
        listsCD.forEach {
            guard let listCD = $0 as? ListCD else { return }
            lists.append(List(listCD: listCD))
        }
        self.lists = lists
    }
    
    func newList() {
        router?.didSendEventClosure?(.newList)
    }
    
    func changeLanguage() {
        guard
            let targetLanguage = UserDefaultsHelper.target()
        else { return }
        router?.didSendEventClosure?(.changeLanguage(language: targetLanguage))
    }
    
    func lookList(at indexPath: IndexPath) {
        let list = lists[indexPath.item]
        router?.didSendEventClosure?(.lookList(list: list))
    }
}

// MARK: - Fetch Results
extension ListsPresenter: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateListsView()
    }
}
