//
//  WordCartsView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 15.04.2023.
//

import UIKit

class WordCardsView: UIView {
    
    // MARK: - Subviews
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            headerStackView,
            collectionView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = Grid.pt16
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            learnResultView,
            buttonStackView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = Grid.pt8
        stackView.axis = .vertical
        stackView.layoutMargins = .init(top: Grid.pt16, left: Grid.pt16, bottom: .zero, right: Grid.pt16)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            settingsButton,
            playButton
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = Grid.pt16
        stackView.axis = .horizontal
        return stackView
    }()
    
    private var learnResultView: LearnResultView = {
        let view = LearnResultView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let playButton: UIButton = {
        let title = NSLocalizedString("Training", comment: "Button")
        let button = actionButton(title: title, image: UIImage(systemName: "play.fill"))
        return button
    }()
    
    let settingsButton: UIButton = {
        let title = NSLocalizedString("Settings", comment: "Button")
        let button = actionButton(title: title, image: UIImage(systemName: "gearshape.fill"))
        return button
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func configure(learnings: [Learn], wordsCount: Int) {
        learnResultView.setResult(learnings: learnings, wordsCount: wordsCount)
    }
    
    func reloadItem(by indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }
    
    // MARK: - Private functions
    
    private static func actionButton(title: String? = nil, image: UIImage? = nil) -> UIButton {
        var configuration: UIButton.Configuration = .gray()
        configuration.cornerStyle = .capsule
        configuration.imagePlacement = .trailing
        configuration.imagePadding = Grid.pt8
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setImage(image, for: .normal)
        return button
    }
    
    // MARK: - UI
    
    private func configureUI() {
        configureSubviews()
        setupConstraint()
    }
    
    private func configureSubviews() {
        addSubview(contentStackView)
    }
    
    // MARK: - Constraints
    
    private func setupConstraint() {
        let safeArea = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }

}
