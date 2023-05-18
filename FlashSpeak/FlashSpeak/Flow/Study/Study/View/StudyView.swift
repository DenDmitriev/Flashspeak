//
//  StudyView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 27.04.2023.
//

import UIKit

class StudyView: UIView {
    
    // MARK: - Subviews
    
    var settingsButton: (UIButton & SettingableButton) = {
        let button = SettingsButton()
        button.translatesAutoresizingMaskIntoConstraints = false
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
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    // MARK: - Functions
    
    func configureSettingsButton(settings: LearnSettings) {
        settingsButton.setSettings(settings: settings)
    }
    
    // MARK: - UI
    
    private func configureUI() {
        self.backgroundColor = .systemBackground
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        self.addSubview(collectionView)
//        self.addSubview(settingsButton)
    }
    
    private func setupConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        
        // swiftlint:disable line_length
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Layout.insetsCollection.left),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Layout.insetsCollection.right),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            settingsButton.heightAnchor.constraint(equalToConstant: Grid.pt32),
            settingsButton.widthAnchor.constraint(equalTo: settingsButton.heightAnchor, multiplier: 3 / 1)
        ])
        // swiftlint:enable line_length
    }
}
