//
//  PrepareLearnViewController.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 25.05.2023.
//

import UIKit

class PrepareLearnViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: PrepareLearnOutput
    var learnSettings: LearnSettings
    
    // MARK: - Private properties
    
    private var prepareLearnView: PrepareLearnView {
        return view as? PrepareLearnView ?? PrepareLearnView(learnSettings: learnSettings, delegate: self)
    }
    
    // MARK: - Constraction
    
    init(
        presenter: PrepareLearnOutput,
        learnSettings: LearnSettings
    ) {
        self.presenter = presenter
        self.learnSettings = learnSettings
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        view = PrepareLearnView(learnSettings: learnSettings, delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.subscribe()
        addActions()
    }
    
    // MARK: - Private functions
    
    private func addActions() {
        prepareLearnView.settingsButton.addTarget(
            self,
            action: #selector(didTapSettings(sender:)),
            for: .touchUpInside
        )
        prepareLearnView.learnButton.addTarget(
            self,
            action: #selector(didTapLearn(sender:)),
            for: .touchUpInside
        )
        prepareLearnView.editCardsButton.addTarget(
            self,
            action: #selector(didTapShowCards),
            for: .touchUpInside
        )
        prepareLearnView.editWordsButton.addTarget(
            self,
            action: #selector(didTapEditWords(sender:)),
            for: .touchUpInside
        )
        prepareLearnView.lookStatisticButton.addTarget(
            self,
            action: #selector(didTapShowStatistic(sender:)),
            for: .touchUpInside
        )
    }

    // MARK: - Actions
    
    @objc private func didTapSettings(sender: UIButton) {
        didTapSettingsButton()
    }
    
    @objc private func didTapLearn(sender: UIButton) {
        didTapLearnButton()
    }
    
    @objc private func didTapEditWords(sender: UIButton) {
        didTapEditWordsButton()
    }
    
    @objc private func didTapEditCards(sender: UIButton) {
        didTapEditCardsButton()
    }
    
    @objc private func didTapShowCards() {
        didTapEditCards()
    }
    
    @objc internal func didTapShowStatistic(sender: UIButton) {
        didTapStatistic()
    }
}

extension PrepareLearnViewController: PrepareLearnInput {
    
    func configureView(title: String, wordsCount: Int) {
        prepareLearnView.setTitle(title)
        prepareLearnView.setList(wordsCount: wordsCount)
        if wordsCount < Settings.minWordsInList {
            let lost = Settings.minWordsInList - wordsCount
            let text = NSLocalizedString("Create \(lost) more words", comment: "description")
            prepareLearnView.setLearnLabel(text: text)
            prepareLearnView.learnButton.isEnabled = false
        } else {
            let text = NSLocalizedString("You can start learning", comment: "description")
            prepareLearnView.setLearnLabel(text: text)
            prepareLearnView.learnButton.isEnabled = true
        }
    }
    
    func setResults(learnings: [Learn], wordsCount: Int) {
        prepareLearnView.configure(learnings: learnings, wordsCount: wordsCount)
    }
    
    func didTapSettingsButton() {
        self.prepareLearnView.settingsTableView.isHidden.toggle()
        self.prepareLearnView.layoutSubviews()
    }
    
    func didTapStatistic() {
        presenter.didTapStatistic()
    }
    
    func didTapLearnButton() {
        presenter.didTapLearnButton()
    }
    
    func didTapEditCards() {
        presenter.showCards()
    }
    
    func didTapEditWordsButton() {
        presenter.didTapEditWordsButton()
    }
    
    func didTapEditCardsButton() {
        presenter.didTapEditCardsButton()
    }
}

extension PrepareLearnViewController: PrepareLearnViewDelegate {
    func settingsChanged(_ settings: LearnSettings) {
        presenter.settingsChanged(settings)
    }
}
