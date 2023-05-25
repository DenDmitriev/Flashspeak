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
    var presenter: ListsViewOutput { get }
    
    func didSelectList(indexPath: IndexPath)
    func didTapLanguage()
    func didTapNewList()
    func reloadListsView()
    func configureLanguageButton(language: Language)
    func deleteList(at indexPath: IndexPath)
}

protocol ListsViewOutput {
//    var lists: [List] { get set }
    var study: Study { get set }
    var router: ListsEvent? { get set }
    
    func subscribe(completion: @escaping (() -> Void))
    func getStudy()
    func newList()
    func changeLanguage()
    func reloadList()
    func editList(at indexPath: IndexPath)
    func editWords(at indexPath: IndexPath)
    func transfer(at indexPath: IndexPath)
    func deleteList(at indexPath: IndexPath)
}

class ListsPresenter: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    @Published var study: Study
    weak var viewController: (UIViewController & ListsViewInput)?
    var router: ListsEvent?
    
    // MARK: - Private properties
    
    @Published private var error: ListError?
    private let fetchedListsResultController: NSFetchedResultsController<ListCD>
    private var store = Set<AnyCancellable>()
    private let coreData = CoreDataManager.instance
    
    // MARK: - Constraction
    
    init(
        fetchedListsResultController: NSFetchedResultsController<ListCD>,
        router: ListsEvent
    ) {
        self.fetchedListsResultController = fetchedListsResultController
        self.router = router
        let studyCD = CoreDataManager.instance.studies?.first(where: {
            $0.sourceLanguage == (UserDefaultsHelper.source() ?? .russian).rawValue &&
            $0.targetLanguage == (UserDefaultsHelper.target() ?? .english).rawValue
        })
        if let studyCD = studyCD {
            self.study = Study(studyCD: studyCD)
        } else {
            self.study = Study(
                sourceLanguage: UserDefaultsHelper.source() ?? .russian,
                targerLanguage: UserDefaultsHelper.target() ?? .english
            )
        }
        super.init()
        initFetchedResultsController()
        updateListsView()
        errorSubscribe()
    }
    
    // MARK: - Private functions
    
    private func errorSubscribe() {
        self.$error
            .receive(on: RunLoop.main)
            .sink { error in
                guard let error = error else { return }
                self.router?.didSendEventClosure?(.error(error: error))
            }
            .store(in: &store)
    }
    
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
        if let studyCD = coreData.getStudyObject(by: study.id) {
            self.study = Study(studyCD: studyCD)
        } else {
            coreData.createStudy(study)
        }
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
    
    func editList(at indexPath: IndexPath) {
        let list = study.lists[indexPath.item]
        router?.didSendEventClosure?(.editList(list: list))
    }
    
    func editWords(at indexPath: IndexPath) {
        let list = study.lists[indexPath.item]
        router?.didSendEventClosure?(.editWords(list: list))
    }
    
    func transfer(at indexPath: IndexPath) {
        let list = study.lists[indexPath.item]
        router?.didSendEventClosure?(.transfer(list: list))
    }
    
    func deleteList(at indexPath: IndexPath) {
        viewController?.deleteList(at: indexPath)
        let list = study.lists[indexPath.item]
        let coreData = CoreDataManager.instance
        coreData.deleteListObject(by: list.id)
    }
    
    func reloadList() {
        updateListsView()
    }
}

// MARK: - Fetch Results
extension ListsPresenter: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateListsView()
    }
}
