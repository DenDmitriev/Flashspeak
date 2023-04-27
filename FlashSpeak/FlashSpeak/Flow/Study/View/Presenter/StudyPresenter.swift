//
//  StudyPresenter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 27.04.2023.
//

import UIKit
import CoreData
import Combine

protocol StudyViewInput {
    var studyCellModels: [StudyCellModel] { get set }
    
    func didTabItem(indexPath: IndexPath)
    func didTabSettingsButton()
    func reloadStudyView()
    func configureLearnSettings(settings: LearnSettings)
}

protocol StudyViewOutput {
    var lists: [List] { get set }
    var router: StudyEvent? { get set }
    var viewInput: (UIViewController & StudyViewInput)? { get set }
    var settings: LearnSettings { get set }
    
    func subscribe()
    func getLists()
    func didTabSettings()
    func didTabLearn(index: Int)
}

class StudyPresenter: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    @Published var lists = [List]()
    var router: StudyEvent?
    weak var viewInput: (UIViewController & StudyViewInput)?
    @Published var settings: LearnSettings
    
    // MARK: - Private properties
    
    private let fetchedListsResultController: NSFetchedResultsController<ListCD>
    private var store = Set<AnyCancellable>()
    
    // MARK: - Constraction
    
    init(
        router: StudyEvent,
        fetchedListsResultController: NSFetchedResultsController<ListCD>
    ) {
        self.router = router
        self.fetchedListsResultController = fetchedListsResultController
        self.settings = LearnSettings(
            question: UserDefaultsHelper.learnQuestionSetting,
            answer: UserDefaultsHelper.learnAnswerSetting,
            language: UserDefaultsHelper.learnQuestionSetting
        )
        super.init()
        initFetchedResultsController()
        updateStudyView()
    }
    
    
    // MARK: - Private functions
    
    private func updateStudyView() {
        getLists()
        viewInput?.reloadStudyView()
    }
    
    private func initFetchedResultsController() {
        fetchedListsResultController.delegate = self
        do {
            try fetchedListsResultController.performFetch()
        } catch let error {
            print("Something went wrong at performFetch cycle. Error: \(error.localizedDescription)")
        }
    }
    
    private func getSettings() {
        let settings = LearnSettings(
            question: UserDefaultsHelper.learnQuestionSetting,
            answer: UserDefaultsHelper.learnAnswerSetting,
            language: UserDefaultsHelper.learnQuestionSetting
        )
        self.settings = settings
    }
    
}

extension StudyPresenter: StudyViewOutput {
    
    // MARK: - Functions
    
    func subscribe() {
        self.$lists
            .receive(on: RunLoop.main)
            .sink { lists in
                var studyCellModels = [StudyCellModel]()
                lists.forEach { list in
                    let listLearn = list.learns
                        .sorted { $0.startTime > $1.startTime }
                    let lastResult = listLearn.last?.result ?? .zero
                    let lastTime = listLearn.last?.duration() ?? "0"
                    let studyCellModel = StudyCellModel
                        .modelFactory(
                            list: list,
                            lastResult: lastResult,
                            time: lastTime
                        )
                    studyCellModels.append(studyCellModel)
                }
                self.viewInput?.studyCellModels = studyCellModels
                self.viewInput?.reloadStudyView()
            }
            .store(in: &store)
        
        self.$settings
            .receive(on: RunLoop.main)
            .sink { settings in
                self.viewInput?.configureLearnSettings(settings: settings)
            }
            .store(in: &store)
    }
    
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
        self.lists = lists
    }
    
    func didTabSettings() {
        print(#function)
        router?.didSendEventClosure?(.settings)
    }
    
    func didTabLearn(index: Int) {
        let list = lists[index]
        print(#function, list.title)
        router?.didSendEventClosure?(.learn(list: list))
    }
}

// MARK: - Fetch Results
extension StudyPresenter: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateStudyView()
    }
}
