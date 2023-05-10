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
    private var collectionViewHeightConstraint = NSLayoutConstraint()
    
    // MARK: - Subviews
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backgroundLightGray
        view.layer.cornerRadius = Grid.cr16
        view.layer.shadowRadius = Grid.pt32
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = .init(width: 0, height: Grid.pt4)
        view.layer.shadowOpacity = Float(Grid.factor25)
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            resultsCollectionView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = Grid.pt8
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.title2
        label.text = NSLocalizedString("Финиш", comment: "Title")
        label.numberOfLines = 2
        return label
    }()
    
    lazy var resultsCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: flowLayout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
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
    
    override func layoutSubviews() {
        collectionViewHeightConstraint.constant = resultsCollectionView.collectionViewLayout.collectionViewContentSize.height
        super.layoutSubviews()
    }
    
    // MARK: - Functions
    
    func updateResultCollectionView() {
        resultsCollectionView.reloadData()
        resultsCollectionView.layoutIfNeeded()
    }
    
    // MARK: - UI
    
    private func configureView() {
        self.backgroundColor = .white.withAlphaComponent(0.5)
        self.frame = UIScreen.main.bounds
    }
    
    private func configureSubviews() {
        configureResultsCollectionView()
        self.addSubview(container)
        container.addSubview(stackView)
    }
    
    private func configureResultsCollectionView() {
        resultsCollectionView.register(ResultCell.self, forCellWithReuseIdentifier: ResultCell.identifier)
        collectionViewHeightConstraint = resultsCollectionView.heightAnchor.constraint(
            equalToConstant: .zero
        )
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        let insetsContainer = UIEdgeInsets(top: Grid.pt16, left: Grid.pt16, bottom: Grid.pt16, right: Grid.pt16)
        
        NSLayoutConstraint.activate([
            container.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            container.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: Grid.factor85),
            
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: insetsContainer.top),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: insetsContainer.left),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -insetsContainer.right),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -insetsContainer.bottom),
            
            collectionViewHeightConstraint
        ])
    }
}

// swiftlint:enable line_length
