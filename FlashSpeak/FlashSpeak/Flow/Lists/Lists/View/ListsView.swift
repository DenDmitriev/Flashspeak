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
    
    lazy var changeLanguageButton: UIButton = {
        var configuration: UIButton.Configuration = .plain()
        configuration.cornerStyle = .medium
        configuration.buttonSize = .small
        configuration.imagePlacement = .trailing
        configuration.imagePadding = Grid.pt4
        configuration.title = NSLocalizedString("Profile", comment: "button")
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.layer.cornerRadius = Grid.cr4
        button.imageView?.layer.masksToBounds = true
        button.layer.masksToBounds = true
        return button
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.text = "Добавьте список"
        label.font = .title3
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
        changeLanguageButton.configurationUpdateHandler = { button in
            if let image = UIImage(named: language.code) {
                let aspect = image.size.width / image.size.height
                let height = Grid.pt32
                let width = aspect * height
                let imageSize = CGSize(width: width, height: height)
                button.configuration?.image = image.imageResized(to: imageSize)
            }
        }
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
        addAnimation()
    }
    
    private func addAnimation() {
        UIView.animate(withDuration: 0.5, delay: .zero, options: [.repeat, .autoreverse], animations: {
            var frame = self.placeHolderArrrowLabel.frame
            frame.origin.y += Grid.pt8
            self.placeHolderArrrowLabel.frame = frame
        })
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
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            changeLanguageButton.heightAnchor.constraint(equalToConstant: Grid.pt44),
//            changeLanguageButton.widthAnchor.constraint(equalTo: changeLanguageButton.heightAnchor, multiplier: 4 / 3),
            
            placeHolderLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            placeHolderLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            
            placeHolderArrrowLabel.bottomAnchor.constraint(equalTo: newListButton.topAnchor),
            placeHolderArrrowLabel.centerXAnchor.constraint(equalTo: newListButton.centerXAnchor)
        ])
    }
    
    // swiftlint:enable line_length
    
}
