//
//  LearnViewController.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 04.05.2023.
//
// swiftlint:disable weak_delegate

import UIKit

class LearnViewController: UIViewController {
    
    // MARK: - Properties
    
    var question: Question
    var answer: Answer
    
    let answerTextFieldDelegate: UITextFieldDelegate
    
    // MARK: - Private properties
    
    private let presenter: LearnViewOutput
    private let answerCollectionDelegate: UICollectionViewDelegate
    private let answerCollectionDataSource: UICollectionViewDataSource
    
    // MARK: - Constraction
    
    init(
        presenter: LearnViewOutput,
        answerCollectionDelegate: UICollectionViewDelegate,
        answerCollectionDataSource: UICollectionViewDataSource,
        answerTextFieldDelegate: UITextFieldDelegate
    ) {
        self.presenter = presenter
        self.answerCollectionDataSource = answerCollectionDataSource
        self.answerCollectionDelegate = answerCollectionDelegate
        self.answerTextFieldDelegate = answerTextFieldDelegate
        self.question = WordQuestion(question: "")
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
        keyboardActions()
        presenter.getAnswerConfigure()
        presenter.subscribe()
        configureAnswerView()
    }
    
    // MARK: - Private functions
    
    private func keyboardActions() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func configureAnswerView() {
        learnView.answersCollectionView.dataSource = answerCollectionDataSource
        learnView.answersCollectionView.delegate = answerCollectionDelegate
    }
    
    private func updateTestView() {
        learnView.answersCollectionView.reloadData()
    }
    
    private func updateKeyboardView() {
        learnView.highlightAnswer(isRight: nil, index: .zero)
        learnView.clearTextFiled()
    }
    
    private func updateQuestionView() {
        learnView.set(question: question, answer: answer)
    }
    
    // MARK: - Actions
    
    @objc func keyboardWillShow(notification: NSNotification) {
        learnView.keyboardWillShow(notification: notification)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        learnView.keyboardWillHide()
    }

}

// MARK: - Functions
extension LearnViewController: LearnViewInput {
    
    // MARK: - Initial configure answer view
    
    func configureAnswerView(settings: LearnSettings.Answer) {
        switch settings {
        case .test:
            learnView.answersCollectionView.register(
                AnswerWordCell.self,
                forCellWithReuseIdentifier: AnswerWordCell.identifier
            )
        case .keyboard:
            learnView.answersCollectionView.register(
                AnswerKeyboardCell.self,
                forCellWithReuseIdentifier: AnswerKeyboardCell.identifier
            )
            learnView.answersCollectionView.register(
                AnswerButtonCell.self,
                forCellWithReuseIdentifier: AnswerButtonCell.identifier
            )
        }
    }
    
    // MARK: - User answer actions

    func testDidAnswer(index: Int) {
        guard let testAnswer = answer as? TestAnswer else { return }
        answer.answer = testAnswer.words[index]
        didAnsewred(answer: answer)
    }
    
    func keyboardDidAnswer() {
        didAnsewred(answer: answer)
    }
    
    func didAnsewred(answer: Answer) {
        presenter.didAnsewred(answer: answer)
    }
    
    // MARK: - Update question and answer view
    
    func configure(exercise: Exercise, settings: LearnSettings.Answer) {
        question = exercise.question
        switch settings {
        case .test:
            guard let testAnswer = exercise.answer as? TestAnswer else { return }
            answer = testAnswer
            updateTestView()
        case .keyboard:
            guard let keyboardAnswer = exercise.answer as? KeyboardAnswer else { return }
            answer = keyboardAnswer
            updateKeyboardView()
        }
        
        updateQuestionView()
    }
    
    // MARK: - Highlight user answers view
    
    func highlightAnswer(isRight: Bool, index: Int?, settings: LearnSettings.Answer) {
        switch settings {
        case .test:
            guard let index = index else { return }
            learnView.highlightAnswer(isRight: isRight, index: index)
        case .keyboard:
            learnView.highlightAnswer(isRight: isRight, index: .zero)
        }
    }
}

// swiftlint:enable weak_delegate
