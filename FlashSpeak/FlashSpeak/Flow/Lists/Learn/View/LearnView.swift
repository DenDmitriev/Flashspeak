//
//  LearnView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 04.05.2023.
//
// swiftlint: disable line_length

import UIKit

class LearnView: UIView {
    
    // MARK: - Propeties
    
    var style: GradientStyle?
    var tabBarHeight: CGFloat?
    
    // MARK: - Private propeties
    private var answersCollectionViewHeightAnchor = NSLayoutConstraint()
    
    // MARK: - Subviews
    
    // MARK: Main subview
    
    /// Content view for all subview in self
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            progressView,
            questionView,
            answerView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = Grid.pt16
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    // MARK: Progress View
    
    private lazy var progressView: UIView & ProgressViewInput = {
        let progressView = ProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    // MARK: Question View
    /// View for all types questions by strategy pattern
    var questionView: UIView
    
    // MARK: AnswerView
    /// CollectionView for all types answers by strategy pattern
    var answerView: UICollectionView
    
    // MARK: SpeechView
    
    var speechButton: UIButton = {
        var configureation: UIButton.Configuration = .plain()
        configureation.image = UIImage(systemName: "speaker.circle.fill")
        configureation.buttonSize = .large
        let button = UIButton(configuration: configureation)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    
    required init(questionView: UIView, answerView: UICollectionView) {
        self.questionView = questionView
        self.answerView = answerView
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        configureSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Lifecycle
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupAppearance()
    }
    
    override func layoutSubviews() {
        answersCollectionViewHeightAnchor.constant = answerView.collectionViewLayout.collectionViewContentSize.height
        super.layoutSubviews()
    }
    
    // MARK: - Functions
    
    func configureView(answersCount: Int) {
        self.progressView.count = answersCount
    }
    
    func setProgress(isRight: Bool, index: Int) {
        progressView.setAnswer(isRight: isRight, index: index)
    }
    
    // MARK: - UI

    private func configureSubviews() {
        addSubview(contentStackView)
        addSubview(speechButton)
    }
    
    private func setupAppearance() {
        configureProgressView()
    }
    
    private func configureProgressView() {
        progressView.tintColor = UIColor.color(by: style ?? .green)
    }
    
    func updateLayout(isKeyboardHide: Bool, keyboardValue: NSValue) {
        if isKeyboardHide {
            contentStackView.layoutMargins.bottom = .zero
        } else {
            let keyboardScreenEndFrame = keyboardValue.cgRectValue
            let keyboardViewEndFrame = convert(keyboardScreenEndFrame, from: window)
            let layoutBottom = keyboardViewEndFrame.height - (tabBarHeight ?? .zero) - Grid.pt16
            contentStackView.layoutMargins.bottom = layoutBottom
        }
        UIView.animate(withDuration: 0.3) {
            self.setNeedsUpdateConstraints()
            self.layoutIfNeeded()
        }
    }
    
    private func setupConstraints() {
        let safeArea = safeAreaLayoutGuide
        answersCollectionViewHeightAnchor = answerView.heightAnchor.constraint(equalToConstant: .zero)
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Grid.pt16),
            contentStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Grid.pt16),
            contentStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -Grid.pt32),
            
            answersCollectionViewHeightAnchor,
            
            progressView.heightAnchor.constraint(equalToConstant: Grid.pt4),
            
            speechButton.bottomAnchor.constraint(equalTo: questionView.bottomAnchor, constant: -Grid.pt12),
            speechButton.trailingAnchor.constraint(equalTo: questionView.trailingAnchor, constant: -Grid.pt12)
        ])
    }
}

// swiftlint: enable line_length
