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
    func reloadWordView(by index: Int)
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
    private let networkService = NetworkService()
    
    init(list: List, router: WordCardsEvent) {
        self.router = router
        self.list = list
    }
    
    // MARK: - Private functions
    
    private func loadImageSubscriber(for word: Word, by index: Int) {
        self.loadImage(for: word)
            .sink { completion in
                switch completion {
                case .finished:
                    self.viewInput?.reloadWordView(by: index)
                }
            } receiveValue: { image in
                self.viewInput?.wordCardCellModels[index].image = image
            }
            .store(in: &store)
    }
    
    private func loadImage(for word: Word) -> AnyPublisher<UIImage?, Never> {
        return Just(word.imageURL)
            .flatMap({ imageURL -> AnyPublisher<UIImage?, Never> in
                guard
                    let url = imageURL
                else {
                    return Just(UIImage(named: "imagePlaceholder"))
                        .eraseToAnyPublisher()
                }
                return ImageLoader.shared.loadImage(from: url)
            })
            .eraseToAnyPublisher()
    }
    
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
                list.words.enumerated().forEach { index, word in
                    let wordModel = WordCardCellModel.modelFactory(word: word)
                    self.viewInput?.wordCardCellModels.append(wordModel)
                    self.loadImageSubscriber(for: word, by: index)
                }
                self.viewInput?.reloadWordsView()
            }
            .store(in: &store)
    }
}
