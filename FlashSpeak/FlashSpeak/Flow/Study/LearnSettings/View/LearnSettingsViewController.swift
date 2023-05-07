//
//  LearnSettingsViewController.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 07.05.2023.
//

import UIKit

class LearnSettingsViewController: UIViewController, ObservableObject {
    
    // MARK: - Properties
    
    var learnSettingsViewModel: LearnSettingsViewModel
    
    // MARK: - Private properties
    private var presenter: LearnSettingsViewOutput

    // MARK: - Constraction
    
    init(presenter: LearnSettingsViewOutput) {
        self.presenter = presenter
        self.learnSettingsViewModel = LearnSettingsViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var learnSettingsView: LearnSettingsView {
        return self.view as? LearnSettingsView ?? LearnSettingsView()
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = LearnSettingsView()
        learnSettingsView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.configureView()
    }
    
    // MARK: - Private functions
    
    // MARK: - Actions

}

// MARK: - Functions

extension LearnSettingsViewController: LearnSettingsViewInput {
    
    func configureView(
        question: LearnSettings.Question,
        answer: LearnSettings.Answer,
        language: LearnSettings.Language
    ) {
        learnSettingsView.configureUserSettings(
            question: question,
            answer: answer,
            language: language
        )
    }
    
    func change(setting: LearnSettings.Settings, selected index: Int) {
        switch setting {
        case .question:
            presenter.changeQuestion(index: index)
        case .answer:
            presenter.changeAnswer(index: index)
        case .language:
            presenter.changeLanguage(index: index)
        }
    }
}

extension LearnSettingsViewController: LearnSettingsViewDelegate {
    func segmentControlDidChanged(setting: LearnSettings.Settings, index: Int) {
        print(setting, index)
    }
}
