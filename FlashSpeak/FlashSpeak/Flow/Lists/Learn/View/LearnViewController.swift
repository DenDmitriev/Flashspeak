//
//  LearnViewController.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 04.05.2023.
//

import UIKit
import Combine

class LearnViewController: UIViewController {
    
    // MARK: - Properties
    
    @Published var question: Question
    @Published var answer: Answer
    var answersCount: Int
    
    var settings: LearnSettings
    var timer: Timer?
    var seconds = 0
    
    // MARK: - Private properties
    
    private let presenter: LearnViewOutput
    private var store = Set<AnyCancellable>()
    
    // MARK: Question View
    /// View for all types questions by strategy pattern
    var questionViewStrategy: QuestionViewStrategy
    
    // MARK: AnswerView
    /// CollectionView for all types answers by strategy pattern
    var answerViewStrategy: AnswerViewStrategyProtocol
    
    // MARK: - Constraction
    
    init(
        presenter: LearnViewOutput,
        settings: LearnSettings,
        answersCount: Int
    ) {
        self.presenter = presenter
        self.settings = settings
        self.question = Question(question: "")
        self.answer = TestAnswer(words: [])
        self.answersCount = answersCount
        switch settings.question {
        case .word:
            self.questionViewStrategy = QuestionWordViewStrategy()
        case .image:
            self.questionViewStrategy = QuestionImageViewStrategy()
        case .wordImage:
            self.questionViewStrategy = QuestionWordImageViewStrategy()
        }
        switch settings.answer {
        case .test:
            self.answerViewStrategy = AnswerTestViewStrategy()
        case .keyboard:
            self.answerViewStrategy = AnswerKeyboardViewStrategy()
        }
        super.init(nibName: nil, bundle: nil)
        self.answerViewStrategy.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var learnView: LearnView {
        return view as? LearnView ?? LearnView(
            questionView: questionViewStrategy.view,
            answerView: answerViewStrategy.collectionView
        )
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = LearnView(
            questionView: questionViewStrategy.view,
            answerView: answerViewStrategy.collectionView
        )
        learnView.style = presenter.list.style
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        createTimer()
        addActions()
        addObserverKayboard()
        subscribe()
        presenter.update()
        configureGesture()
    }
    
    // MARK: - Private functions
    
    private func configureView() {
        learnView.configureView(answersCount: answersCount)
    }
    
    private func updateQuestionView() {
        questionViewStrategy.set(question: question)
    }
    
    private func updateAnswerView() {
        answerViewStrategy.set(answer: answer)
    }
    
    private func configureGesture() {
        if (answerViewStrategy as? AnswerKeyboardViewStrategy) != nil {
            let tap = UITapGestureRecognizer(
                target: self,
                action: #selector(dismissKeyboard(sender:))
            )
            tap.cancelsTouchesInView = false
            questionViewStrategy.view.addGestureRecognizer(tap)
        }
    }
    
    private func createTimer() {
        if timer == nil {
            let timer = Timer(timeInterval: 1.0, target: self, selector: #selector(updateTimer(timer:)), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: .common)
            timer.tolerance = 0.1
            self.timer = timer
        }
        let formater = DateComponentsFormatter()
        formater.unitsStyle = .positional
        formater.allowedUnits = [.hour, .minute, .second]
        formater.zeroFormattingBehavior = .pad
    }
    
    private func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    // MARK: - Observers
    
    private func subscribe() {
        self.$question
            .combineLatest(self.$answer)
            .receive(on: RunLoop.main)
            .sink { _, answer in
                if answer.answer == nil {
                    self.updateQuestionView()
                    self.updateAnswerView()
                }
            }
            .store(in: &store)
    }
    
    private func addObserverKayboard() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(adjustForKeyboard),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(adjustForKeyboard),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
    private func addActions() {
        learnView.speechButton.addTarget(
            self,
            action: #selector(speechDidTap(sender:)),
            for: .touchUpInside
        )
    }
    
    // MARK: - Actions
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard
            let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }

        let isKeyboardHide = notification.name == UIResponder.keyboardWillHideNotification
        learnView.updateLayout(isKeyboardHide: isKeyboardHide, keyboardValue: keyboardValue)
    }

    @objc func dismissKeyboard(sender: UIGestureRecognizer) {
        answerViewStrategy.action(.dissmisKeyboard)
    }
    
    @objc func speechDidTap(sender: UIButton) {
        speechDidTap()
    }
    
    @objc func updateTimer(timer: Timer) {
        seconds += 1
        learnView.timerView.timerLabel.text = timeString(time: TimeInterval((seconds)))
    }
}

// MARK: - Functions

extension LearnViewController: LearnViewInput {
    
    func didAnsewred(answer: Answer) {
        presenter.didAnsewred(answer: answer)
    }
    
    func update(exercise: Exercise) {
        question = exercise.question
        answer = exercise.answer
    }
    
    func speechDidTap() {
        presenter.speechDidTap()
    }
    
    func highlightAnswer(isRight: Bool, index: Int?) {
        answerViewStrategy.highlight(isRight: isRight, index: index ?? .zero)
    }
    
    func setProgress(isRight: Bool, index: Int) {
        learnView.setProgress(isRight: isRight, index: index)
    }
    
    func action(closure: @escaping (() -> Void)) {
        closure()
    }
    
}

extension LearnViewController: AnswerViewControllerDelegate {
    func didAnswer(_ answer: Answer) {
        didAnsewred(answer: answer)
    }
}
