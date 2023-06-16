//
//  WordCartsView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 15.04.2023.
//

import UIKit

class WordCardsView: UIView {
    
    // MARK: - Properties
    
    var color: UIColor?
    
    // MARK: - Subviews
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let editButton: UIButton = {
        var configuration: UIButton.Configuration = .filled()
        configuration.cornerStyle = .capsule
        configuration.imagePlacement = .trailing
        configuration.imagePadding = Grid.pt8
        configuration.buttonSize = .large
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        return button
    }()
    
    let editListPropertiesButton: UIButton = {
        var configuration: UIButton.Configuration = .plain()
        configuration.cornerStyle = .capsule
        configuration.imagePlacement = .trailing
        configuration.imagePadding = Grid.pt8
        configuration.buttonSize = .large
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        return button
    }()
    
    // MARK: - Init
    
    init(color: UIColor?) {
        super.init(frame: .zero)
        self.color = color
        backgroundColor = .systemBackground
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        configureAppearance()
    }
    
    // MARK: - Functions
    
    func reloadItem(by indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }
    
    // MARK: - Private functions
    
    private static func actionButton(title: String? = nil, image: UIImage? = nil) -> UIButton {
        var configuration: UIButton.Configuration = .filled()
        configuration.cornerStyle = .capsule
        configuration.imagePlacement = .trailing
        configuration.imagePadding = Grid.pt8
        configuration.buttonSize = .large
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        return button
    }
    
    // MARK: - UI
    
    private func configureAppearance() {
        let controls = [editButton]
        controls.forEach({ $0.tintColor = color })
    }
    
    private func configureUI() {
        configureSubviews()
        setupConstraint()
    }
    
    private func configureSubviews() {
        addSubview(collectionView)
        addSubview(editButton)
    }
    
    // MARK: - Constraints
    
    private func setupConstraint() {
        let safeArea = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            editButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -Grid.pt32),
            editButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -Grid.pt32)
        ])
    }
    
}
