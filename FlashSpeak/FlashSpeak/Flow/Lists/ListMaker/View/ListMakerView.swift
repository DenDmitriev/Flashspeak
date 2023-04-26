//
//  ListMakerView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 21.04.2023.
//

import UIKit

class ListMakerView: UIView {
    
    var style: GradientStyle?
    
    private lazy var wordsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var fieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            tokenCollectionView,
            removeCollectionView,
            tokenFiled
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Grid.pt8
        stackView.distribution = .fill
        stackView.backgroundColor = .white.withAlphaComponent(Grid.factor75)
        stackView.layer.cornerRadius = Grid.cr8
        stackView.layoutMargins = UIEdgeInsets(
            top: Grid.pt16,
            left: Grid.pt16,
            bottom: Grid.pt16,
            right: Grid.pt16
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    let tokenCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    let removeCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.isHidden = true
        return collectionView
    }()
    
    let tokenFiled: UITextField = {
        let tokenFiled = UITextField()
        tokenFiled.translatesAutoresizingMaskIntoConstraints = false
        tokenFiled.leftView = UIView()
        tokenFiled.borderStyle = .none
        tokenFiled.backgroundColor = .clear
        tokenFiled.textColor = .black
        tokenFiled.placeholder = NSLocalizedString(
            "Добавляйте слова через запятую ...",
            comment: "Placeholder"
        )
        tokenFiled.font = UIFont.subhead
        tokenFiled.textAlignment = .left
        tokenFiled.contentVerticalAlignment = .fill
        tokenFiled.contentHorizontalAlignment = .fill
        tokenFiled.clearButtonMode = .never
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
    
    private let descriptionText: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .regular
        textView.textColor = .darkGray
        textView.text = NSLocalizedString(
            "Требования к списку:\n\tСлова должны быть разделены запятой;\n\tМинимальное количество слов в списке 9, максимальное 99;\n\tСлова должны быть написаны на родном языке;\n\tСлова которые не удалось распознать, будут убраны из списка;", comment: "Description"
        )
        textView.backgroundColor = .clear
        textView.isEditable = false
        return textView
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
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupAppearance() {
        configureWordsView()
        configureRemoveCollectionView()
    }
    
    fileprivate func configureRemoveCollectionView() {
        let removeAreaView = UIView(frame: removeCollectionView.frame)
        let cornerRadius = Grid.cr8
        removeAreaView.addDashedBorder(color: .red, width: Grid.pt2, dashPattern: [NSNumber(value: Grid.pt8), NSNumber(value: Grid.pt4)], cornerRadius: cornerRadius)
        
        removeCollectionView.layer.cornerRadius = cornerRadius
        
        let imageView = UIImageView(image: UIImage(systemName: "trash.fill"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .red
        
        removeAreaView.addSubview(imageView)
        imageView.centerYAnchor.constraint(equalTo: removeAreaView.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: removeAreaView.centerXAnchor).isActive = true
        
        removeCollectionView.backgroundView = removeAreaView
    }
    
    fileprivate func configureWordsView() {
        let layer = CAGradientLayer.gradientLayer(for: style ?? .grey, in: wordsView.bounds)
        layer.cornerRadius = Grid.cr16
        wordsView.layer.insertSublayer(layer, at: 0)
    }
    
    // MARK: - Methods
    
    func updateRemoveArea(isActive: Bool) {
        switch isActive {
        case true:
            removeCollectionView.backgroundColor = .red.withAlphaComponent(Grid.factor25)
        case false:
            removeCollectionView.backgroundColor = .clear
        }
    }
    
    func hideRemoveArea(isHidden: Bool) {
        removeCollectionView.isHidden = isHidden
        if isHidden {
            updateRemoveArea(isActive: false)
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
        wordsView.addSubview(fieldStackView)
        self.addSubview(wordsView)
        self.addSubview(generateButton)
        self.addSubview(descriptionText)
        self.addSubview(backgroundSpinner)
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            wordsView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            wordsView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            wordsView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            wordsView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: Grid.factor50),
            
            removeCollectionView.heightAnchor.constraint(equalToConstant: 50),
            
            fieldStackView.topAnchor.constraint(equalTo: wordsView.topAnchor, constant: Grid.pt16),
            fieldStackView.leadingAnchor.constraint(equalTo: wordsView.leadingAnchor, constant: Grid.pt16),
            fieldStackView.trailingAnchor.constraint(equalTo: wordsView.trailingAnchor, constant: -Grid.pt16),
            fieldStackView.bottomAnchor.constraint(equalTo: wordsView.bottomAnchor, constant: -Grid.pt16 - Grid.pt48 / 2),
            
            generateButton.topAnchor.constraint(equalTo: wordsView.bottomAnchor, constant: -Grid.pt48 / 2),
            generateButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: Grid.factor75),
            generateButton.heightAnchor.constraint(equalToConstant: Grid.pt48),
            generateButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
            descriptionText.topAnchor.constraint(equalTo: generateButton.bottomAnchor, constant: Grid.pt16),
            descriptionText.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Grid.pt16),
            descriptionText.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Grid.pt16),
            descriptionText.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -Grid.pt16),
            
            backgroundSpinner.topAnchor.constraint(equalTo: topAnchor),
            backgroundSpinner.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundSpinner.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundSpinner.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: backgroundSpinner.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: backgroundSpinner.centerYAnchor)
        ])
    }
}


