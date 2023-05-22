//
//  LearnSettingsViewController.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 07.05.2023.
//
// swiftlint:disable weak_delegate

import UIKit

class LearnSettingsViewController: UIViewController, ObservableObject {
    
    // MARK: - Properties
    
    // MARK: - Private properties
    private var presenter: LearnSettingsViewOutput
    private let gestureRecognizerDelegate: UIGestureRecognizerDelegate

    // MARK: - Constraction
    
    init(presenter: LearnSettingsViewOutput, gestureRecognizerDelegate: UIGestureRecognizerDelegate) {
        self.presenter = presenter
        self.gestureRecognizerDelegate = gestureRecognizerDelegate
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
        configureGesture()
        presenter.configureView()
    }
    
    // MARK: - Private functions
    
    private func configureGesture() {
        let tapBackground = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapBackroundView(sender:))
        )
        tapBackground.delegate = gestureRecognizerDelegate
        self.learnSettingsView.addGestureRecognizer(tapBackground)
    }
    
    // MARK: - Actions

    @objc private func didTapBackroundView(sender: UIView) {
        didTabBackground()
    }
}

// MARK: - Functions

extension LearnSettingsViewController: LearnSettingsViewInput {
    
    func didTabBackground() {
        presenter.viewDidTapBackground()
    }
    
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
    
    func question(selected: LearnSettings.Question) {
        change(setting: .question, selected: selected.rawValue)
    }
    
    func language(selected: LearnSettings.Language) {
        change(setting: .language, selected: selected.rawValue)
    }
    
    func answer(selected: LearnSettings.Answer) {
        change(setting: .answer, selected: selected.rawValue)
    }
}

// swiftlint:enable weak_delegate
