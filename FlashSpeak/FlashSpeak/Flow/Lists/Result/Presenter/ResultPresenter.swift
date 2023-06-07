//
//  ResultPresenter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 07.05.2023.
//

import UIKit
import Combine

protocol ResultViewInput {
    func repeatDidTap()
    func updateResults(viewModels: [ResultViewModel])
    func updateMistakes(viewModels: [WordCellModel])
}

protocol ResultViewOutput {
    func subscribe()
    func repeatDidTap()
    func settingsDidTap()
}

class ResultPresenter: ObservableObject {
    
    // MARK: - Properties
    
    weak var viewController: (UIViewController & ResultViewInput)?
    var router: ResultEvent?
    
    @Published var list: List
    @Published var mistakes: [Word: String]
    
    // MARK: - Private properties
    
    private var store = Set<AnyCancellable>()
    
    // MARK: - Constraction
    
    init(
        router: ResultEvent,
        list: List,
        mistakes: [Word: String]
    ) {
        self.router = router
        self.list = list
        self.mistakes = mistakes
    }
    
    // MARK: - Private functions
    
    private func resultViewModels(_ lastLearn: Learn?) -> [ResultViewModel] {
        var resultViewModels = [ResultViewModel]()
        if let lastLearn = lastLearn {
            LearnResults.allCases.forEach { result in
                let resultString: String
                switch result {
                case .duration:
                    resultString = lastLearn.duration()
                case .rights:
                    resultString = "\(lastLearn.result)/\(lastLearn.count)"
                case .passed:
                    resultString = String(list.learns.count)
                case .time:
                    resultString = ResultPresenter.duration(learings: list.learns)
                }
                let resultViewModel = ResultViewModel(
                    result: resultString,
                    description: result.description
                )
                resultViewModels.append(resultViewModel)
            }
        } else {
            let resultString = NSLocalizedString("Empty", comment: "description")
            let resultViewModel = ResultViewModel(
                result: "",
                description: resultString
            )
            resultViewModels.append(resultViewModel)
        }
        return resultViewModels
    }
    
    private func mistakeViewModels(mistakes: [Word: String]) -> [WordCellModel] {
        return mistakes.map { word, mistake in
            return WordCellModel(source: word.source, translation: word.translation, mistake: mistake)
        }
    }
    
    private static func duration(learings: [Learn]) -> String {
        let duartion = learings.map({ $0.timeInterval() }).reduce(.zero, +)
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .abbreviated
        let durationString = formatter.string(from: duartion)
        return durationString ?? "N/A"
    }
}

// MARK: - Functions

extension ResultPresenter: ResultViewOutput {
    
    func subscribe() {
        self.$list
            .receive(on: RunLoop.main)
            .sink(receiveValue: { list in
                if let lastLearn = list.learns.max(by: { $0.finishTime < $1.finishTime }) {
                    self.viewController?.updateResults(viewModels: self.resultViewModels(lastLearn))
                } else {
                    self.viewController?
                        .updateResults(viewModels: self.resultViewModels(nil))
                }
            })
            .store(in: &store)
        
        self.$mistakes
            .receive(on: RunLoop.main)
            .sink(receiveValue: { mistakeWords in
                if mistakeWords.isEmpty {
                    let title = NSLocalizedString("No mistakes", comment: "description")
                    let emptyWord = Word(source: title, translation: "")
                    self.viewController?
                        .updateMistakes(viewModels: self.mistakeViewModels(mistakes: [emptyWord: ""]))
                } else {
                    self.viewController?
                        .updateMistakes(viewModels: self.mistakeViewModels(mistakes: mistakeWords))
                }
            })
            .store(in: &store)
    }
    
    func repeatDidTap() {
        router?.didSendEventClosure?(.learn(list: list))
    }
    
    func settingsDidTap() {
        router?.didSendEventClosure?(.settings)
    }
}
