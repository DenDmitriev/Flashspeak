//
//  PrepareLearnViewController.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 25.05.2023.
//

import UIKit
import SwiftUI

class PrepareLearnViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: PrepareLearnOutput
    
    // MARK: - Private properties
    
    private var prepareLearnView: PrepareLearnView {
        let style = presenter.list.style
        return view as? PrepareLearnView ?? PrepareLearnView(style: style)
    }
    
    // MARK: - Constraction
    
    init(
        presenter: PrepareLearnOutput
    ) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        let style = presenter.list.style
        view = PrepareLearnView(style: style)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.subscribe()
        addActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.sync()
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
//        prepareLearnView.paragraphButtom.addTarget(
//            self,
//            action: #selector(didTapParagraph(sender:)),
//            for: .touchUpInside
//        )
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapParagraph(sender:)))
        prepareLearnView.listLabel.isUserInteractionEnabled = true
        prepareLearnView.listLabel.addGestureRecognizer(tapGesture)
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
    
    @objc private func didTapParagraph(sender: UIGestureRecognizer) {
        if prepareLearnView.listLabel.numberOfLines == .zero {
            prepareLearnView.listLabel.numberOfLines = 3
//            sender.isHighlighted = false
        } else {
            prepareLearnView.listLabel.numberOfLines = .zero
//            sender.isHighlighted = true
        }
    }
}

extension PrepareLearnViewController: PrepareLearnInput {
    
    func configureChartView(viewModels: [ChartLearnViewModel], color: UIColor) {
        if viewModels.isEmpty {
            prepareLearnView.resultStackView.isHidden = true
        } else {
            let viewController = UIHostingController(rootView: ChartLearnView(viewModels: viewModels, color: Color(color)))
            let resultChartView = viewController.view ?? UIView()
            prepareLearnView.setChartView(resultChartView)
            addChild(viewController)
            viewController.didMove(toParent: self)
            prepareLearnView.resultStackView.isHidden = false
        }
    }
    
    func configureView(title: String, wordsCount: Int, words: [String], color: UIColor) {
        prepareLearnView.setList(wordsCount: wordsCount, words: words, color: color)
        if wordsCount < Settings.minWordsInList {
            let lost = Settings.minWordsInList - wordsCount
            let text = String(localized: "Create \(lost) more words")
            prepareLearnView.setLearnLabel(text: text)
            prepareLearnView.learnButton.isEnabled = false
        } else {
            let text = String(localized: "You can start learning")
            prepareLearnView.setLearnLabel(text: text)
            prepareLearnView.learnButton.isEnabled = true
        }
    }
    
    func didTapSettingsButton() {
        presenter.didTapSettingsButon()
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
