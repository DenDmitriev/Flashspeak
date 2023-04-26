//
//  ListsView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 12.04.2023.
//

import UIKit

class ListsView: UIView {
    
    // MARK: - SubViews
    
    var newListButton: UIButton = {
        var configuration = UIButton.Configuration.gray()
        configuration.baseForegroundColor = .tint
        configuration.baseBackgroundColor = .backgroundLightGray
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
        return collectionView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    private func configureUI() {
        self.backgroundColor = .backgroundWhite
        addSubviews()
        configureChangeButton(language: Language.english)
        setupConstraints()
    }
    
    private func addSubviews() {
        self.addSubview(collectionView)
        self.addSubview(changeLanguageButton)
        self.addSubview(newListButton)
    }

    // swiftlint:disable line_length
    
    private func setupConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        let inset: CGFloat = Grid.pt16
        
        NSLayoutConstraint.activate([
            newListButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -inset),
            newListButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -inset * 2),
            
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0),
            
            changeLanguageButton.widthAnchor.constraint(equalToConstant: 44),
            changeLanguageButton.widthAnchor.constraint(equalTo: changeLanguageButton.heightAnchor, multiplier: 4 / 3)
        ])
    }
    
    // swiftlint:enable line_length
    
    private func configureChangeButton(language: Language) {
        changeLanguageButton.translatesAutoresizingMaskIntoConstraints = false
        changeLanguageButton.setImage(UIImage(named: language.code), for: .normal)
    }
    
}
