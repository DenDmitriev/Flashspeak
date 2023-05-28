//
//  ResultView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 07.05.2023.
//
// swiftlint:disable line_length

import UIKit

class ResultView: UIView {
    
    // MARK: - Properties
    
    // MARK: - Subviews
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            resultStackView,
            mistakesStackView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = Grid.pt16
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(
            top: .zero,
            left: Grid.pt16,
            bottom: Grid.pt16 + safeAreaInsets.bottom,
            right: Grid.pt16
        )
        return stackView
    }()
    
    // MARK: Result Subviews
    
    private lazy var resultStackView: UIStackView = {
        return ResultView.groupStackView(arrangedSubviews: [
            resultsLabel,
            resultsCollectionView
        ])
    }()
    
    private let resultsLabel: UILabel = {
        let text = NSLocalizedString("Результаты", comment: "title")
        return ResultView.titleLabel(title: text)
    }()
    
    private lazy var resultsCollectionView: (UICollectionView & ResultCollectionViewProtocol) = {
        let collectionView = ResultCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: Mistakes Subviews
    
    private lazy var mistakesStackView: UIStackView = {
        return ResultView.groupStackView(arrangedSubviews: [
            mistakesLabel,
            mistakesCollectionView,
            repeatButton
        ])
    }()
    
    private let mistakesLabel: UILabel = {
        let text = NSLocalizedString("Ошибки", comment: "title")
        return ResultView.titleLabel(title: text)
    }()
    
    private lazy var mistakesCollectionView: (UICollectionView & MistakeCollectionViewProtocol) = {
        let collectionView = MistakeCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let repeatButton: UIButton = {
        let button = UIButton(configuration: .appFilled())
        button.translatesAutoresizingMaskIntoConstraints = false
        let title = NSLocalizedString("Повторить", comment: "title")
        button.setTitle(title, for: .normal)
        return button
    }()
    
    // MARK: - Constraction
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    // MARK: - Functions
    
    func updateResultCollectionView(viewModels: [ResultViewModel]) {
        resultsCollectionView.resultViewModels.append(contentsOf: viewModels)
        resultsCollectionView.reloadData()
    }
    
    func updateMistakeCollectionView(viewModels: [WordCellModel]) {
        mistakesCollectionView.mistakeViewModels.append(contentsOf: viewModels)
        mistakesCollectionView.reloadData()
    }
    
    // MARK: - Private functions
    
    private static func titleLabel(title: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.font = .titleBold2
        return label
    }
    
    private static func groupStackView(arrangedSubviews: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = Grid.pt16
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: Grid.pt16, left: Grid.pt16, bottom: Grid.pt16, right: Grid.pt16)
        stackView.backgroundColor = .systemBackground
        stackView.layer.cornerRadius = Grid.cr12
        return stackView
    }
    
    // MARK: - UI
    
    private func configureView() {
        backgroundColor = .secondarySystemBackground
    }
    
    private func configureSubviews() {
        configureResultsCollectionView()
        addSubview(scrollView)
        scrollView.addSubview(contentStackView)
    }
    
    private func configureResultsCollectionView() {
        resultsCollectionView.register(ResultCell.self, forCellWithReuseIdentifier: ResultCell.identifier)
        mistakesCollectionView.register(WordCell.self, forCellWithReuseIdentifier: WordCell.identifier)
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            
            resultsCollectionView.heightAnchor.constraint(equalToConstant: Grid.pt96),
            mistakesCollectionView.heightAnchor.constraint(equalToConstant: Grid.pt96)
        ])
    }
}

// swiftlint:enable line_length
