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
    var answer: TestAnswer
    
    // MARK: - Private properties
    
    private let presenter: LearnViewOutput
    private let answerCollectionDelegate: UICollectionViewDelegate
    private let answerCollectionDataSource: UICollectionViewDataSource
    
    // MARK: - Constraction
    
    init(
        presenter: LearnViewOutput,
        answerCollectionDelegate: UICollectionViewDelegate,
        answerCollectionDataSource: UICollectionViewDataSource
    ) {
        self.presenter = presenter
        self.answerCollectionDataSource = answerCollectionDataSource
        self.answerCollectionDelegate = answerCollectionDelegate
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
        presenter.subscribe()
        configureCollectionView()
    }
    
    // MARK: - Private functions
    
    private func configureCollectionView() {
        learnView.answersCollectionView.dataSource = answerCollectionDataSource
        learnView.answersCollectionView.delegate = answerCollectionDelegate
        learnView.answersCollectionView.register(
            AnswerCell.self,
            forCellWithReuseIdentifier: AnswerCell.identifier
        )
    }
    
    private func updateView() {
        learnView.answersCollectionView.reloadData()
        learnView.set(question: question, answer: answer)
    }
    
    // MARK: - Actions

}

// MARK: - Functions
extension LearnViewController: LearnViewInput {
    
    func didSelectItemAt(index: Int) {
        answer.answer = answer.words[index]
        didAnsewred(answer: answer)
    }
    
    func didAnsewred(answer: Answer) {
        presenter.didAnsewred(answer: answer)
    }
    
    func set(exercise: Exercise) {
        question = exercise.question
        guard let testAnswer = exercise.answer as? TestAnswer else { return }
        answer = testAnswer
        updateView()
    }
    
    func highlightAnswer(for: Bool, index: Int?) {
//        learnView.highlightAnswer(for: Bool, index: Int)
    }
}

// swiftlint:enable weak_delegate
