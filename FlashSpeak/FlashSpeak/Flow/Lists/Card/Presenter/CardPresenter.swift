//
//  CardPresenter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 15.05.2023.
//

import UIKit
import Combine

protocol CardViewInput {
    var cardViewModel: CardViewModel? { get set }
    
    func configureView(style: GradientStyle)
    func insertImage(image: UIImage, at index: Int)
    func didTapAddImage()
}

protocol CardViewOutput {
    func subscribe()
    func save(translation: String, image: UIImage)
}

class CardPresenter {
    
    // MARK: - Properties
    
    @Published var word: Word
    @Published var error: CardError?
    var style: GradientStyle?
    
    weak var viewController: (UIViewController & CardViewInput)?
    
    // MARK: - Private properties
    
    private let router: CardEvent?
    private var store = Set<AnyCancellable>()
    private let service: NetworkServiceProtocol
    private var images = [CardImage]()
    private var imageSubject = PassthroughSubject<URL, Never>()
    private let coreData = CoreDataManager.instance
    
    // MARK: - Constraction
    
    init(
        word: Word,
        style: GradientStyle,
        router: CardEvent,
        service: NetworkServiceProtocol = NetworkService()
    ) {
        self.word = word
        self.style = style
        self.router = router
        self.service = service
        errorSubscribe()
    }
    
    // MARK: - Private functions
    
    private func imageSubjectSubscriber() {
        imageSubject
            .receive(on: RunLoop.main)
            .sink(receiveValue: { imageURL in
                if self.word.imageURL != imageURL {
                    self.loadImage(for: imageURL)
                }
            })
            .store(in: &store)
    }
    
    private func loadImage(for url: URL) {
        return Just(url)
        .flatMap({ url -> AnyPublisher<UIImage?, Never> in
            return ImageLoader.shared.loadImage(from: url)
        })
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                guard
                    let index = self.images.firstIndex(where: { $0.url == url })
                else { return }
                let cardImage = self.images[index]
                if let image = cardImage.image {
                    self.viewController?.insertImage(image: image, at: index)
                }
            }
        }, receiveValue: { image in
            guard let image = image else { return }
            let cardImage = CardImage(url: url, image: image)
            if url == self.word.imageURL {
                self.images.insert(cardImage, at: .zero)
            } else {
                self.images.append(cardImage)
            }
        })
        .store(in: &store)
    }
    
    private func loadImageURLs(word: String, language: Language) {
        guard
            let url = URLConfiguration.shared.imageURL(word: word, language: language, count: 9)
        else { return }
        service.getImageURL(url: url)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.error = CardError.imageURL(error: error)
                default:
                    return
                }
            } receiveValue: { imageResponse in
                imageResponse.results.forEach { result in
                    self.imageSubject.send(result.urls.small)
                }
            }
            .store(in: &store)
    }
    
    private func errorSubscribe() {
        self.$error
            .receive(on: RunLoop.main)
            .sink { error in
                guard let error = error else { return }
                self.router?.didSendEventClosure?(.error(error: error))
            }
            .store(in: &store)
    }
    
    private func updateWordInCD(_ word: Word) {
        if let error = coreData.updateWord(word, by: word.id).map({ CardError.save(error: $0) }) {
            self.error = CardError.save(error: error)
        }
    }
}

// MARK: - Functions

extension CardPresenter: CardViewOutput {
    
    func save(translation: String, image: UIImage) {
        let imageURL: URL?
        if let url = images.first(where: { $0.image == image })?.url {
            imageURL = url
        } else {
            let nameFile = word.nameForCustomImage()
            ImageManager.shared.saveImage(image: image, name: nameFile)
            let url = ImageManager.shared.urlForFile(by: nameFile)
            imageURL = url
        }
        
        guard
            let imageURL = imageURL
        else {
            router?.didSendEventClosure?(.save(wordID: nil))
            return
        }
        
        if translation != word.translation || imageURL != word.imageURL {
            var word = word
            word.imageURL = imageURL
            word.translation = translation.cleanText().lowercased()
            updateWordInCD(word)
            router?.didSendEventClosure?(.save(wordID: word.id))
        } else {
            router?.didSendEventClosure?(.save(wordID: nil))
        }
    }
    
    func subscribe() {
        self.$word
            .receive(on: RunLoop.main)
            .sink { word in
                self.viewController?.cardViewModel = CardViewModel.modelFactory(word: word)
                self.viewController?.configureView(style: self.style ?? .grey)
                guard let sourceLanguage = UserDefaultsHelper.source() else { return }
                self.imageSubjectSubscriber()
                if let defaultImageURL = self.word.imageURL {
                    self.loadImage(for: defaultImageURL)
                }
                self.loadImageURLs(word: self.word.source, language: sourceLanguage)
            }
            .store(in: &store)
    }
}
