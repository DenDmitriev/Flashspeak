//
//  LearnView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 04.05.2023.
//

import UIKit

class LearnView: UIView {
    
    // MARK: - Propeties
    
    var style: GradientStyle?

    // MARK: - Subviews
    
    // MARK: CardView
    
    private lazy var cardStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            questionLabel
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = Grid.pt4
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.layer.cornerRadius = Grid.cr16
        stackView.layer.masksToBounds = true
        return stackView
    }()
    
    private var questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .title1
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: AnswerView
    
    private lazy var answerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            answersCollectionView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = Grid.pt8
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        return stackView
    }()
    
    let answersCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.layer.cornerRadius = Grid.cr8
        return collectionView
    }()
    
    // MARK: Main view
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            cardStackView,
            answerStackView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = Grid.pt32
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.layoutMargins = UIEdgeInsets(
            top: .zero,
            left: Grid.pt16,
            bottom: Grid.pt44,
            right: Grid.pt16
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func draw(_ rect: CGRect) {
        setupAppearance()
    }
    
    // MARK: - Functions
    
    func set(question: Question, answer: TestAnswer) {
        questionLabel.text = question.question
    }
    
    // MARK: - UI

    func configureUI() {
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        addSubview(stackView)
    }
    
    private func setupAppearance() {
        configureCardStackView()
    }
    
    private func configureCardStackView() {
        let layer = CAGradientLayer.gradientLayer(for: style ?? .grey, in: cardStackView.bounds)
        layer.cornerRadius = Grid.cr16
        cardStackView.layer.insertSublayer(layer, at: 0)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            answerStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2)
        ])
    }
}
