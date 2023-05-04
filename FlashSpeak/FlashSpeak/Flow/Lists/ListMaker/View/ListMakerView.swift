//
//  ListMakerView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 21.04.2023.
//

import UIKit

class ListMakerView: UIView {
    
    var style: GradientStyle?
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            fieldStackView,
            generateButton
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = Grid.pt16
        stackView.distribution = .fill
        stackView.layoutMargins = UIEdgeInsets(
            top: .zero,
            left: Grid.pt16,
            bottom: Grid.pt16,
            right: Grid.pt16
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    lazy var fieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            tokenCollectionView,
            removeCollectionView,
            tokenFiled
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Grid.pt16
        stackView.distribution = .fill
        stackView.backgroundColor = .white.withAlphaComponent(Grid.factor75)
        stackView.layer.cornerRadius = Grid.cr8
        return stackView
    }()
    
    let tokenCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: LeftAlignedCollectionViewFlowLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let removeCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.layer.borderWidth = Grid.pt1
        collectionView.layer.cornerRadius = Grid.cr8
        collectionView.layer.borderColor = UIColor.clear.cgColor
        return collectionView
    }()
    
    let tokenFiled: UITextField = {
        let tokenFiled = UITextField()
        tokenFiled.translatesAutoresizingMaskIntoConstraints = false
        let paddingView = UIView(
            frame: CGRect(
                x: .zero,
                y: .zero,
                width: Grid.pt8,
                height: tokenFiled.frame.size.height
            )
        )
        tokenFiled.leftView = paddingView
        tokenFiled.leftViewMode = .always
        tokenFiled.textColor = .black
        tokenFiled.placeholder = NSLocalizedString(
            "Добавляйте слова через запятую ...",
            comment: "Placeholder"
        )
        tokenFiled.font = UIFont.subhead
        tokenFiled.textAlignment = .left
        tokenFiled.layer.cornerRadius = Grid.cr8
        tokenFiled.layer.borderWidth = Grid.pt1
        tokenFiled.layer.borderColor = UIColor.backgroundLightGray.cgColor
        return tokenFiled
    }()
    
    let generateButton: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .appFilled()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Создать карточки", comment: "Button"), for: .normal)
        button.tintColor = .tint
        button.layer.cornerRadius = Grid.cr16
        button.layer.shadowRadius = Grid.pt32
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = .init(width: 0, height: 4)
        button.layer.shadowOpacity = Float(Grid.factor25)
        button.isEnabled = false
        return button
    }()
    
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.color = .tint
        return spinner
    }()
    
    let backgroundSpinner: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white.withAlphaComponent(Grid.factor50)
        view.isHidden = true
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        setupConstraints()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func highlightRemoveArea(isActive: Bool) {
        switch isActive {
        case true:
            removeCollectionView.backgroundColor = .systemRed.withAlphaComponent(Grid.factor25)
            removeCollectionView.layer.borderColor = UIColor.systemRed.cgColor
        case false:
            removeCollectionView.backgroundColor = .clear
            removeCollectionView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    func highlightTokenField(isActive: Bool) {
        switch isActive {
        case true:
            tokenFiled.backgroundColor = .systemGreen.withAlphaComponent(Grid.factor25)
            tokenFiled.layer.borderColor = UIColor.systemGreen.cgColor
        case false:
            tokenFiled.backgroundColor = .clear
            tokenFiled.layer.borderColor = UIColor.backgroundLightGray.cgColor
        }
    }
    
    func spinner(isActive: Bool) {
        backgroundSpinner.isHidden = !isActive
        switch isActive {
        case true:
            spinner.startAnimating()
        case false:
            spinner.stopAnimating()
        }
    }
    
    func button(isEnabled: Bool) {
        generateButton.isEnabled = isEnabled
    }
    
    // MARK: - UI
    
    private func configureSubviews() {
        backgroundSpinner.addSubview(spinner)
        self.addSubview(stackView)
        self.addSubview(backgroundSpinner)
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -Grid.pt16),
            
            tokenFiled.heightAnchor.constraint(equalToConstant: Grid.pt48),
            
            generateButton.heightAnchor.constraint(equalToConstant: Grid.pt48),
            
            removeCollectionView.heightAnchor.constraint(equalToConstant: 50),
            
            backgroundSpinner.topAnchor.constraint(equalTo: topAnchor),
            backgroundSpinner.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundSpinner.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundSpinner.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: backgroundSpinner.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: backgroundSpinner.centerYAnchor)
        ])
    }
}
