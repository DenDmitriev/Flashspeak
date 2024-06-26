//
//  ListsPresenter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 18.04.2023.
//

import UIKit
import CoreData
import Combine
import FirebaseCrashlytics

protocol ListsViewInput {
    var listCellModels: [ListCellModel] { get set }
    var serachListCellModels: [ListCellModel] { get set }
    var isSearching: Bool { get set }
    var presenter: ListsViewOutput { get }
    
    func didSelectList(indexPath: IndexPath)
    func didTapLanguage()
    func didTapNewList()
    func reloadListsView()
    func configureLanguageButton(language: Language)
    func deleteList(at indexPath: IndexPath)
    func setPlaceHolders(isActive: Bool)
}

protocol ListsViewOutput {
//    var lists: [List] { get set }
    var study: Study { get set }
    var router: ListsEvent? { get set }
    
    func prepareLearn(at indexPath: IndexPath)
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
            Crashlytics.crashlytics().record(error: error)
            print("Something went wrong at performFetch cycle. Error: \(error.localizedDescription)")
        }
    }
}

extension ListsPresenter: ListsViewOutput {
    
    // MARK: - Functions
    
    func prepareLearn(at indexPath: IndexPath) {
        let list = study.lists[indexPath.item]
        router?.didSendEventClosure?(.prepareLearn(list: list))
    }
    
    func subscribe(completion: @escaping (() -> Void)) {
        self.$study
            .receive(on: RunLoop.main)
            .sink { study in
                let listCellModels = study.lists
                    .map({ ListCellModel.modelFactory(from: $0) })
                if listCellModels.isEmpty {
                    self.viewController?.setPlaceHolders(isActive: true)
                } else {
                    self.viewController?.setPlaceHolders(isActive: false)
                }
                self.viewController?.listCellModels = listCellModels
                self.viewController?.reloadListsView()
                completion()
            }
            .store(in: &store)
        viewController?.configureLanguageButton(language: study.targetLanguage)
    }
    
    func getStudy() {
        if let studyCD = coreData.getStudyObject(by: study.id) {
            self.study = Study(studyCD: studyCD)
            self.study.lists
                .sort(by: {
                    guard
                        let lhs = $0.learns.max(by: { $0.startTime < $1.startTime }),
                        let rhs = $1.learns.max(by: { $0.startTime < $1.startTime })
                    else { return true }
                    return lhs.startTime > rhs.startTime
                })
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

@available(iOS 17, *)
#Preview {
    ListsBuilder.build(router: ListsRouter())
}
