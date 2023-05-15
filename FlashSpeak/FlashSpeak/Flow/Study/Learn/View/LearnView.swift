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
            questionStackView,
            answersCollectionView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = Grid.pt16
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    // MARK: - Progress View
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    // MARK: - Activity Indicator View
    
    var activityIndicator: ActivityIndicatorView = {
        let view = ActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    // MARK: Question View
    
    /// Content view for all question subviews
    private lazy var questionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = .zero
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = Grid.pt8
        stackView.axis = .vertical
        stackView.layer.cornerRadius = Grid.cr16
        stackView.layer.masksToBounds = true
        stackView.layoutMargins = UIEdgeInsets(top: Grid.pt8, left: Grid.pt8, bottom: Grid.pt8, right: Grid.pt8)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private var questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .title1
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = Grid.factor50
        return label
    }()
    
    private var questionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: AnswerView
    
    /// Collection view for all types answer
    lazy var answersCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: flowLayout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addObserverKayboard()
        configureGesture()
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
        setupAppearance()
    }
    
    override func layoutSubviews() {
        answersCollectionViewHeightAnchor.constant = answersCollectionView.collectionViewLayout.collectionViewContentSize.height
        super.layoutSubviews()
    }
    
    // MARK: - Functions
    
    /// First configure question views
    func configureQuestionView(setting: LearnSettings.Question) {
        switch setting {
        case .word:
            questionStackView.insertArrangedSubview(questionLabel, at: .zero)
        case .image:
            questionStackView.insertArrangedSubview(questionImageView, at: .zero)
        case .wordImage:
            questionStackView.insertArrangedSubview(questionImageView, at: .zero)
            let index = questionStackView.arrangedSubviews.count
            questionStackView.insertArrangedSubview(questionLabel, at: index)
        }
    }
    
    func configureAnswerView(setting: LearnSettings.Answer) {
        switch setting {
        case .test:
            answersCollectionView.register(
                AnswerWordCell.self,
                forCellWithReuseIdentifier: AnswerWordCell.identifier
            )
        case .keyboard:
            answersCollectionView.register(
                AnswerKeyboardCell.self,
                forCellWithReuseIdentifier: AnswerKeyboardCell.identifier
            )
            answersCollectionView.register(
                AnswerButtonCell.self,
                forCellWithReuseIdentifier: AnswerButtonCell.identifier
            )
        }
    }
    
    /// Update question view
    func update(question: Question, setting: LearnSettings.Question) {
        switch setting {
        case .word:
            questionLabel.text = question.question
        case .image:
            if let image = question.image?.roundedImage(cornerRadius: Grid.cr16) {
                questionImageView.image = image
            }
        case .wordImage:
            questionLabel.text = question.question
            if let image = question.image?.roundedImage(cornerRadius: Grid.cr16) {
                questionImageView.image = image
            }
        }
    }
    
    /// Highlight answer view
    func highlightAnswer(isRight: Bool?, index: Int) {
        let indexPath = IndexPath(item: index, section: .zero)
        guard
            var cell = answersCollectionView.cellForItem(at: indexPath) as? AnswerCell
        else { return }
        cell.isRight = isRight
    }
    
    /// Clear text in textFiled
    func clearTextFiled() {
        guard
            let cell = answersCollectionView.cellForItem(
                at: IndexPath(item: .zero, section: .zero)
            ) as? AnswerKeyboardCell
        else { return }
        cell.answerTextField.text = nil
    }
    
    func updateAnswersCollectionView() {
        answersCollectionView.reloadData()
        answersCollectionView.layoutIfNeeded()
    }
    
    func setProgress(_ progress: Float) {
        progressView.setProgress(progress, animated: true)
    }
    
    func spinner(isActive: Bool, title: String? = nil) {
        activityIndicator.isHidden = !isActive
        switch isActive {
        case true:
            activityIndicator.setTitle(title ?? "")
            activityIndicator.start()
        case false:
            activityIndicator.stop()
        }
    }
    
    // MARK: - UI

    private func configureSubviews() {
        addSubview(contentStackView)
    }
    
    private func setupAppearance() {
        configureQuestionStackView()
        configureProgressView()
    }
    
    private func configureQuestionStackView() {
        let layer = CAGradientLayer.gradientLayer(for: style ?? .grey, in: questionStackView.bounds)
        layer.cornerRadius = Grid.cr16
        questionStackView.layer.insertSublayer(layer, at: 0)
    }
    
    private func configureProgressView() {
        progressView.tintColor = UIColor.color(by: style ?? .green) ?? .tint
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
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard
            let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = convert(keyboardScreenEndFrame, from: window)
        let layoutBottom = keyboardViewEndFrame.height - (tabBarHeight ?? .zero) - Grid.pt16
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            contentStackView.layoutMargins.bottom = .zero
        } else {
            contentStackView.layoutMargins.bottom = layoutBottom
        }
        
        UIView.animate(withDuration: 0.3) {
            self.setNeedsUpdateConstraints()
            self.layoutIfNeeded()
        }
    }
    
    private func configureGesture() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(UIInputViewController.dismissKeyboard)
        )
        tap.cancelsTouchesInView = false
        questionStackView.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        guard
            let cell = answersCollectionView.cellForItem(at: IndexPath(item: .zero, section: .zero)) as? AnswerKeyboardCell
        else { return }
        cell.answerTextField.endEditing(true)
    }
    
    private func setupConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        answersCollectionViewHeightAnchor = answersCollectionView.heightAnchor.constraint(equalToConstant: .zero)
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Grid.pt16),
            contentStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Grid.pt16),
            contentStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -Grid.pt32),
            
            progressView.heightAnchor.constraint(equalToConstant: Grid.pt4),
            
            questionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: Grid.pt48),
            answersCollectionViewHeightAnchor
        ])
    }
    
}

// swiftlint: enable line_length
