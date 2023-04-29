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
    func configureLearnSettings(settings: LearnSettings, source: Language, target: Language)
}

protocol StudyViewOutput {
    var study: Study { get set }
    var router: StudyEvent? { get set }
    var viewInput: (UIViewController & StudyViewInput)? { get set }
    var settings: LearnSettings { get set }
    
    func subscribe()
    func getStudy()
    func didTabSettings()
    func didTabLearn(index: Int)
}

class StudyPresenter: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    @Published var study: Study
    @Published var settings: LearnSettings
    var router: StudyEvent?
    weak var viewInput: (UIViewController & StudyViewInput)?
    
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
        self.study = Study(
            sourceLanguage: UserDefaultsHelper.source() ?? .russian,
            targerLanguage: UserDefaultsHelper.target() ?? .english
        )
        self.settings = LearnSettings(
            question: UserDefaultsHelper.learnQuestionSetting,
            answer: UserDefaultsHelper.learnAnswerSetting,
            language: UserDefaultsHelper.learnLanguageSetting
        )
        super.init()
        initFetchedResultsController()
        updateStudyView()
    }
    
    
    // MARK: - Private functions
    
    private func updateStudyView() {
        getStudy()
        getSettings()
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
            language: UserDefaultsHelper.learnLanguageSetting
        )
        self.settings = settings
    }
    
}

extension StudyPresenter: StudyViewOutput {
    
    // MARK: - Functions
    
    func subscribe() {
        self.$study
            .receive(on: RunLoop.main)
            .sink { study in
                var studyCellModels = [StudyCellModel]()
                study.lists.forEach { list in
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
            .sink { [weak self] settings in
                guard let self = self else { return }
                self.viewInput?.configureLearnSettings(
                    settings: settings,
                    source: self.study.sourceLanguage,
                    target: self.study.targetLanguage
                )
            }
            .store(in: &store)
    }
    
    /// Sync study with CoreData study
    func getStudy() {
        let coreData = CoreDataManager.instance
        guard
            let studyCD = coreData.getStudyObject(source: study.sourceLanguage, target: study.targetLanguage)
        else { return }
        self.study = Study(studyCD: studyCD)
    }
    
    func didTabSettings() {
        print(#function)
        router?.didSendEventClosure?(.settings)
    }
    
    func didTabLearn(index: Int) {
        let list = study.lists[index]
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
