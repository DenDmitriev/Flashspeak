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
//    var lists: [List] { get set }
    var study: Study { get set }
    var router: ListsEvent? { get set }
    
    func subscribe(completion: @escaping (() -> Void))
    func getStudy()
    func newList()
    func changeLanguage()
    func lookList(at indexPath: IndexPath)
}

class ListsPresenter: NSObject, ObservableObject {
    
    @Published var study: Study
    weak var viewController: (UIViewController & ListsViewInput)?
    var router: ListsEvent?
    
    // MARK: - Private properties
    
    private let fetchedListsResultController: NSFetchedResultsController<ListCD>
    private var store = Set<AnyCancellable>()
    
    init(
        fetchedListsResultController: NSFetchedResultsController<ListCD>,
        router: ListsEvent
    ) {
        self.fetchedListsResultController = fetchedListsResultController
        self.router = router
        self.study = Study(
            sourceLanguage: UserDefaultsHelper.source() ?? .russian,
            targerLanguage: UserDefaultsHelper.target() ?? .english
        )
        super.init()
        initFetchedResultsController()
        updateListsView()
    }
    
    // MARK: - Private functions
    
    private func updateListsView() {
        getStudy()
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
    
    func subscribe(completion: @escaping (() -> Void)) {
        self.$study
            .receive(on: RunLoop.main)
            .sink { study in
                let listCellModels = study.lists.map({ ListCellModel.modelFactory(from: $0) })
                self.viewController?.listCellModels = listCellModels
                self.viewController?.reloadListsView()
                completion()
            }
            .store(in: &store)
    }
    
    func getStudy() {
        // Update language button
        viewController?.configureLanguageButton(language: study.targetLanguage)
        // Sync study with CoreData study
        let coreData = CoreDataManager.instance
        guard
            let studyCD = coreData.getStudyObject(source: study.sourceLanguage, target: study.targetLanguage)
        else { return }
        self.study = Study(studyCD: studyCD)
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
        let list = study.lists[indexPath.item]
        router?.didSendEventClosure?(.lookList(list: list))
    }
}

// MARK: - Fetch Results
extension ListsPresenter: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateListsView()
    }
}
