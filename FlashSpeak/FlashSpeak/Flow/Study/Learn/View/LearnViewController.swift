//
//  LearnViewController.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 04.05.2023.
//
// swiftlint:disable weak_delegate

import UIKit
import Combine

class LearnViewController: UIViewController {
    
    // MARK: - Properties
    
    @Published var question: Question
    @Published var answer: Answer
    var settings: LearnSettings
    
    let answerTextFieldDelegate: UITextFieldDelegate
    
    // MARK: - Private properties
    
    private let presenter: LearnViewOutput
    private let answerCollectionDelegate: UICollectionViewDelegate
    private let answerCollectionDataSource: UICollectionViewDataSource
    private var store = Set<AnyCancellable>()
    
    // MARK: - Constraction
    
    init(
        presenter: LearnViewOutput,
        answerCollectionDelegate: UICollectionViewDelegate,
        answerCollectionDataSource: UICollectionViewDataSource,
        answerTextFieldDelegate: UITextFieldDelegate,
        settings: LearnSettings
    ) {
        self.presenter = presenter
        self.answerCollectionDataSource = answerCollectionDataSource
        self.answerCollectionDelegate = answerCollectionDelegate
        self.answerTextFieldDelegate = answerTextFieldDelegate
        self.settings = settings
        self.question = Question(question: "")
        self.answer = TestAnswer(words: [])
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var learnView: LearnView {
        return view as? LearnView ?? LearnView()
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = LearnView()
        learnView.style = presenter.list.style
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        subscribe()
        presenter.update()
    }
    
    // MARK: - Private functions
    
    private func configureView() {
        learnView.tabBarHeight = tabBarController?.tabBar.frame.height
        configureQuestionView(setting: settings.question)
        configureAnswerView(setting: settings.answer)
    }
    
    private func configureQuestionView(setting: LearnSettings.Question) {
        learnView.configureQuestionView(setting: setting)
    }
    
    private func configureAnswerView(setting: LearnSettings.Answer) {
        learnView.answersCollectionView.dataSource = answerCollectionDataSource
        learnView.answersCollectionView.delegate = answerCollectionDelegate
        learnView.configureAnswerView(setting: setting)
    }
    
    private func subscribe() {
        self.$question
            .combineLatest(self.$answer)
            .receive(on: RunLoop.main)
            .sink { _, answer in
                if answer.answer == nil {
                    self.updateQuestionView(questionSetting: self.settings.question)
                    self.updateAnswerView(answerSetting: self.settings.answer)
                }
            }
            .store(in: &store)
    }
    
    private func updateQuestionView(questionSetting: LearnSettings.Question) {
        learnView.update(question: question, setting: questionSetting)
    }
    
    private func updateAnswerView(answerSetting: LearnSettings.Answer) {
        switch answerSetting {
        case .test:
            updateAnswerTestView()
        case .keyboard:
            updateAnswerKeyboardView()
        }
    }
    
    private func updateAnswerTestView() {
        learnView.updateAnswersCollectionView()
    }
    
    private func updateAnswerKeyboardView() {
        learnView.highlightAnswer(isRight: nil, index: .zero)
        learnView.clearTextFiled()
    }
    
    // MARK: - Actions

}

// MARK: - Functions

extension LearnViewController: LearnViewInput {
    
    func didAnsewred(answer: Answer) {
        presenter.didAnsewred(answer: answer)
    }

    func testDidAnswer(index: Int) {
        guard let testAnswer = answer as? TestAnswer else { return }
        answer.answer = testAnswer.words[index]
        didAnsewred(answer: answer)
    }
    
    func keyboardDidAnswer() {
        didAnsewred(answer: answer)
    }
    
    func update(exercise: Exercise) {
        question = exercise.question
        answer = exercise.answer
    }
    
    func highlightAnswer(isRight: Bool, index: Int?, settings: LearnSettings.Answer) {
        switch settings {
        case .test:
            guard let index = index else { return }
            learnView.highlightAnswer(isRight: isRight, index: index)
        case .keyboard:
            learnView.highlightAnswer(isRight: isRight, index: .zero)
        }
    }
    
    func setProgress(_ progress: Float) {
        learnView.setProgress(progress)
    }
    
    func spinner(isActive: Bool, title: String?) {
        learnView.spinner(isActive: true, title: title)
    }
}

// swiftlint:enable weak_delegate
