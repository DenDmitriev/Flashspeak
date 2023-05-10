//
//  StatisticPresenter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 10.05.2023.
//

import UIKit
import CoreData
import Combine

protocol StatisticViewInput {
    var statisticDayViewModels: [StatisticViewModel] { get set }
    var statisticAllViewModels: [StatisticViewModel] { get set }
    
    func updateViewModels(viewModels: [StatisticViewModel])
}

protocol StatisticViewOutput {
    func subscribe()
}

class StatisticPresenter: NSObject {
    
    // MARK: - Properties
    
    weak var viewController: (UIViewController & StatisticViewInput)?
    var router: StatisticEvent?
    
    @Published var learnings = [Learn]()
    
    // MARK: - Private properties
    
    private let fetchedLearningsResultController: NSFetchedResultsController<LearnCD>
    private var store = Set<AnyCancellable>()
    
    // MARK: - Constraction
    
    init(
        router: StatisticEvent,
        fetchedLearningsResultController: NSFetchedResultsController<LearnCD>
    ) {
        self.router = router
        self.fetchedLearningsResultController = fetchedLearningsResultController
        super.init()
        initFetchedResultsController()
        getLearns()
    }
    
    // MARK: - Private functions
    
    private func getLearns() {
        let coreData = CoreDataManager.instance
        guard
            let learnings = coreData.learnings.map({ learningsCD in
                var learnings = [Learn]()
                learningsCD.forEach { learnCD in
                    learnings.append(Learn(learnCD: learnCD))
                }
                return learnings
            })
        else { return }
        self.learnings = learnings
    }
    
    private func initFetchedResultsController() {
        fetchedLearningsResultController.delegate = self
        do {
            try fetchedLearningsResultController.performFetch()
        } catch let error {
            print("Something went wrong at performFetch cycle. Error: \(error.localizedDescription)")
        }
    }
    
}

// MARK: - Functions

extension StatisticPresenter: StatisticViewOutput {
    func subscribe() {
        self.$learnings
            .receive(on: RunLoop.main)
            .sink { learns in
                let viewModels = StatisticViewModel.modelFactory(learnings: learns)
                self.viewController?.updateViewModels(viewModels: viewModels)
            }
            .store(in: &store)
    }
}

// MARK: - Fetch Results

extension StatisticPresenter: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        getLearns()
    }
}
