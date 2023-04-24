//
//  NewListPresenter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import UIKit
import Combine

protocol NewListViewInput {
    func dissmisView()
    func createList(title: String, style: GradientStyle, imageFlag: Bool)
}

protocol NewListViewOutput {
    func close()
    func newList(title: String, style: GradientStyle, imageFlag: Bool, words: [String])
}

class NewListPresenter {
    
    var viewInput: (UIViewController & NewListViewInput)?
    
    // MARK: - Private properties
    private let newList = PassthroughSubject<List, Never>()
    private let service: NetworkServiceProtocol!
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialisation[]
    init(service: NetworkServiceProtocol = NetworkService()) {
        self.service = service
        
        newList
            .sink(receiveValue: {
                //TODO: - Добовление данных в CoreData
                print($0.words.count)
            })
            .store(in: &cancellables)
    }
}

extension NewListPresenter: NewListViewOutput {
    
    func close() {
        viewInput?.dismiss(animated: true)
    }
    
    func newList(title: String, style: GradientStyle, imageFlag: Bool, words: [String]) {
        var list = List(title: title, words: [], style: style, created: Date(), addImageFlag: true)
        service.translateWords(url: UrlConfiguration.shared.translateUrl(words: words, targetLang: .english, sourceLang: .russian)!)
            .receive(on: DispatchQueue.main)
            .sink { error in
                print(error)
            } receiveValue: { translated in
                translated.translatedWord.forEach { word in
                    list.words.append(Word(source: word.sourceWords.text, translation: word.translations.text))
                    UrlConfiguration.shared.imageUrl(word: word.sourceWords.text, language: .russian)                }
                self.newList.send(list)
            }
            .store(in: &cancellables)
        viewInput?.dismiss(animated: true)
    }
}
