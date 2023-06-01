//
//  ListsView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 12.04.2023.
//

import UIKit

class ListsView: UIView {
    
    // MARK: - Subviews
    
    var newListButton: UIButton = {
        var configuration = UIButton.Configuration.appFilled()
//        configuration.baseForegroundColor = .tint
        configuration.cornerStyle = .capsule
        configuration.buttonSize = .large
        let button = UIButton(configuration: configuration)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var changeLanguageButton = ChangeLangButtonView()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.text = "🤷‍♂️"
        label.font = .title1
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let placeHolderArrrowLabel: UILabel = {
        let label = UILabel()
        label.text = "⤵"
        label.font = .title1
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func configureChangeButton(language: Language) {
        changeLanguageButton.setImage(UIImage(named: language.code), for: .normal)
    }
    
    func setPlaceHolders(isActive: Bool) {
        UIView.animate(withDuration: Grid.factor25) {
            self.placeHolderLabel.isHidden = !isActive
            self.placeHolderArrrowLabel.isHidden = !isActive
        }
    }
    
    // MARK: - UI
    
    private func configureUI() {
        self.backgroundColor = .systemBackground
        addSubviews()
        configureButtons()
        setupConstraints()
    }
    
    private func addSubviews() {
        addSubview(collectionView)
        addSubview(changeLanguageButton)
        addSubview(newListButton)
        addSubview(placeHolderLabel)
        addSubview(placeHolderArrrowLabel)
    }
    
    private func configureButtons() {
        changeLanguageButton.translatesAutoresizingMaskIntoConstraints = false
    }

    // swiftlint:disable line_length
    
    private func setupConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            newListButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -Grid.pt32),
            newListButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -Grid.pt32),
            
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Layout.insetsCollection.left),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Layout.insetsCollection.right),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            changeLanguageButton.heightAnchor.constraint(equalToConstant: Grid.pt32),
            changeLanguageButton.widthAnchor.constraint(equalTo: changeLanguageButton.heightAnchor, multiplier: 4 / 3),
            
            placeHolderLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            placeHolderLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            
            placeHolderArrrowLabel.bottomAnchor.constraint(equalTo: newListButton.topAnchor),
            placeHolderArrrowLabel.centerXAnchor.constraint(equalTo: newListButton.centerXAnchor)
        ])
    }
    
    // swiftlint:enable line_length
    
}
