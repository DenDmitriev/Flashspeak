//
//  WordCardsPublisher.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import UIKit
import Combine

protocol WordCardsViewInput {
    var wordCardCellModels: [WordCardCellModel] { get set }
    var style: GradientStyle? { get }
    
    func didTapWord(indexPath: IndexPath)
    func reloadWordsView()
}

protocol WordCardsViewOutput {
    var list: List { get set }
    var router: WordCardsEvent? { get set }
    
    func showWordCard(index: Int)
    func subscribe()
}

class WordCardsPresenter: ObservableObject {
    
    @Published var list: List
    weak var viewInput: (UIViewController & WordCardsViewInput)?
    var router: WordCardsEvent?
    private var store = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(list: List, router: WordCardsEvent) {
        self.router = router
        self.list = list
    }
    
    // MARK: - Private functions
    
}

extension WordCardsPresenter: WordCardsViewOutput {
    
    // MARK: - Functions
    
    func showWordCard(index: Int) {
        let word = list.words[index]
        router?.didSendEventClosure?(.word(word: word))
    }
    
    func subscribe() {
        self.$list
            .receive(on: RunLoop.main)
            .sink { list in
                self.viewInput?.wordCardCellModels = list.words.map({ word in
                    WordCardCellModel.modelFactory(word: word)
                })
                self.viewInput?.reloadWordsView()
            }
            .store(in: &store)
    }
}
