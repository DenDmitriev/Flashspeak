//
//  ListsPresenter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 18.04.2023.
//

import UIKit
import CoreData

protocol ListsViewInput {
    var lists: [List] { get set }
    
    func didSelectList(index: Int)
    func didTapLanguage()
    func didTapNewList()
    func reloadListsView()
}

protocol ListsViewOutput {
    func getLists()
}

protocol ListsEvent {
    var didSendEventClosure: ((ListsViewController.Event) -> Void)? { get set }
}

class ListsPresenter: NSObject {
    
    var viewController: (UIViewController & ListsViewInput & ListsEvent)?
    private let fetchedListsResultController: NSFetchedResultsController<ListCD>
    
    init(fetchedListsResultController: NSFetchedResultsController<ListCD>) {
        self.fetchedListsResultController = fetchedListsResultController
        super.init()
        self.initFetchedResultsController()
    }
}

extension ListsPresenter: ListsViewOutput {
    
    func getLists() {
        var lists = [List]()
        let coreData = CoreDataManager.instance
        if let studies = coreData.studies,
           !studies.isEmpty {
            studies[0].listsCD?.forEach {
                guard let listCD = $0 as? ListCD else { return }
                lists.append(List(listCD: listCD))
            }
        }
        viewController?.lists = lists
    }
    
    private func updateListsView() {
        getLists()
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

// MARK: - Fetch Results
extension ListsPresenter: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateListsView()
    }
}
