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
}

class ResultPresenter: ObservableObject {
    
    // MARK: - Properties
    
    weak var viewController: (UIViewController & ResultViewInput)?
    var router: ResultEvent?
    
    @Published var list: List
    @Published var mistakes: [Word]
    
    // MARK: - Private properties
    
    private var store = Set<AnyCancellable>()
    
    // MARK: - Constraction
    
    init(
        router: ResultEvent,
        list: List,
        mistakes: [Word]
    ) {
        self.router = router
        self.list = list
        self.mistakes = mistakes
    }
    
    // MARK: - Private functions
    
    private func resultViewModels(_ lastLearn: Learn) -> [ResultViewModel] {
        var resultViewModels = [ResultViewModel]()
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
        return resultViewModels
    }
    
    private func mistakeViewModels(mistakes: [Word]) -> [WordCellModel] {
        return mistakes.map({ WordCellModel.modelFactory(word: $0) })
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
                guard
                    let lastLearn = list.learns.max(by: { $0.finishTime < $1.finishTime })
                else { return }
                self.viewController?.updateResults(viewModels: self.resultViewModels(lastLearn))
            })
            .store(in: &store)
        
        self.$mistakes
            .receive(on: RunLoop.main)
            .sink(receiveValue: { words in
                if words.isEmpty {
                    let emptyWord = Word(source: "", translation: "Без ошибок")
                    self.viewController?.updateMistakes(viewModels: self.mistakeViewModels(mistakes: [emptyWord]))
                } else {
                    self.viewController?.updateMistakes(viewModels: self.mistakeViewModels(mistakes: words))
                }
            })
            .store(in: &store)
    }
    
    func repeatDidTap() {
        router?.didSendEventClosure?(.learn(list: list))
    }
}
