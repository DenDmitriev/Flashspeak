//
//  ListMakerView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 21.04.2023.
//
// swiftlint: disable line_length

import UIKit

class ListMakerView: UIView {
    
    // MARK: - Propeties
    
    var style: GradientStyle?
    var tabBarHeight: CGFloat?
    
    enum Initial {
        static let backgroundTextFiled: UIColor = .fiveBackgroundColor
        static let duartionAnimation: TimeInterval = 0.2
        static let placeholderNormalTokenFiled: String = NSLocalizedString("Enter word", comment: "Placeholder")
        static let placeholderEditeTokenFiled: String = NSLocalizedString("Edit Word", comment: "Placeholder")
        static let tokenCollectionTag = 0
        static let removeCollectionTag = 1
    }
    
    // MARK: - Subviews
    
    // MARK: Main subview
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            tokenStackView,
            removeStackView,
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
            bottom: .zero,
            right: Grid.pt16
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    // MARK: Field subviews
    
    lazy var tokenStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            tokenCollectionView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Grid.pt16
        stackView.distribution = .fill
        stackView.backgroundColor = .white.withAlphaComponent(Grid.factor75)
        stackView.layer.cornerRadius = Grid.cr8
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    let tokenCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: LeftAlignedCollectionViewFlowLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.tag = Initial.tokenCollectionTag
        return collectionView
    }()
    
    lazy var removeCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.tag = Initial.removeCollectionTag
        collectionView.backgroundColor = .clear
        collectionView.isHidden = true
        return collectionView
    }()
    
    private lazy var removeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            removeCollectionView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = Grid.pt8
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var fieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            tokenFiled,
            addButton
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = Grid.pt8
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var tokenFiled: UITextField = {
        let tokenFiled = UITextField()
        tokenFiled.translatesAutoresizingMaskIntoConstraints = false
        let leftView = UIView(frame: CGRect(x: .zero, y: .zero, width: Grid.pt8, height: .zero))
        tokenFiled.leftView = leftView
        tokenFiled.leftViewMode = .always
        tokenFiled.placeholder = Initial.placeholderNormalTokenFiled
        tokenFiled.font = UIFont.titleBold3
        tokenFiled.textAlignment = .left
        tokenFiled.layer.cornerRadius = Grid.cr12
        tokenFiled.backgroundColor = Initial.backgroundTextFiled
        tokenFiled.rightViewMode = .whileEditing
        tokenFiled.rightView = deleteButton
        return tokenFiled
    }()
    
    // MARK: Action subviews
    
    let generateButton: UIButton = {
        var configuration: UIButton.Configuration = .appFilled()
        configuration.imagePadding = Grid.pt8
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .tintColor
        button.isEnabled = false
        return button
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.configuration = .appFilled()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .tintColor
        button.isHidden = true
        return button
    }()
    
    let helpButton: UIButton = {
        var configuration = UIButton.Configuration.borderless()
        configuration.cornerStyle = .capsule
        configuration.buttonSize = .medium
        let button = UIButton(configuration: configuration)
        button.setImage(UIImage(systemName: "questionmark.circle"), for: .normal)
        return button
    }()
    
    let backButton: UIButton = {
        var configuration = UIButton.Configuration.borderless()
        configuration.buttonSize = .small
        let button = UIButton(type: .system)
        let backImage = UIImage(systemName: "chevron.backward")
        button.setImage(backImage, for: .normal)
        button.setTitle(NSLocalizedString("Word Lists", comment: "Button"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return button
    }()
    
    let deleteButton: UIButton = {
        var configuration = UIButton.Configuration.borderless()
        configuration.title = " "
        configuration.cornerStyle = .capsule
        configuration.buttonSize = .small
        let button = UIButton(configuration: configuration)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addObserverKeyboard()
        configureGesture()
        configureSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Lifecycle
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        configureAppearance()
    }
    
    // MARK: - Methods
    
    func highlightRemoveArea(isActive: Bool) {
        self.removeCollectionView.isHidden = !isActive
        if let cell = removeCollectionView.cellForItem(at: IndexPath(item: .zero, section: .zero)) as? ButtonCell {
            cell.highlight(isActive)
        }
    }
    
    func highlightTokenField(isActive: Bool) {
        switch isActive {
        case true:
            self.tokenFiled.backgroundColor = .systemGreen.withAlphaComponent(Grid.factor25)
            self.tokenFiled.placeholder = Initial.placeholderEditeTokenFiled
        case false:
            self.tokenFiled.backgroundColor = Initial.backgroundTextFiled
            self.tokenFiled.placeholder = Initial.placeholderNormalTokenFiled
        }
    }
    
    func spinner(isActive: Bool, title: String? = nil) {
        generateButton.configurationUpdateHandler = { button in
            var config = button.configuration
            config?.showsActivityIndicator = isActive
            if isActive {
                button.isEnabled = false
                config?.title = title
            }
            button.configuration = config
        }
    }
    
    func generateButton(isEnabled: Bool) {
        generateButton.isEnabled = isEnabled
    }
    
    func addButton(isHidden: Bool, isEnabled: Bool) {
        addButton.isHidden = isHidden
    }
    
    func removeButton(isEnabled: Bool) {
        if let cell = removeCollectionView.cellForItem(at: IndexPath(item: .zero, section: .zero)) as? ButtonCell {
            cell.button.isEnabled = isEnabled
        }
    }

    func clearField() {
        tokenFiled.text?.removeAll()
        addButton(isHidden: true, isEnabled: false)
    }
    
    // MARK: - Private functions
    
    private func addObserverKeyboard() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(adjustForKeyboard),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(adjustForKeyboard),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard
            let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = convert(keyboardScreenEndFrame, from: window)
        let tabBarInset = Grid.pt16
        let bottomInset = keyboardViewEndFrame.height - (tabBarHeight ?? .zero) - tabBarInset
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            contentStackView.layoutMargins.bottom = .zero
        } else {
            contentStackView.layoutMargins.bottom = bottomInset
        }
        
        UIView.animate(withDuration: 0.3) {
            self.setNeedsUpdateConstraints()
            self.layoutIfNeeded()
        }
    }
    
    private func configureGesture() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard(sender:))
        )
        tap.cancelsTouchesInView = false
        tokenStackView.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(sender: UIGestureRecognizer) {
        tokenFiled.resignFirstResponder()
    }
    
    // MARK: - UI
    
    private func configureAppearance() {
        let buttons = [generateButton, addButton, helpButton, backButton]
        buttons.forEach({ $0.tintColor = style?.color })
    }
    
    private func configureSubviews() {
        addSubview(contentStackView)
        addSubview(deleteButton)
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            contentStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -Grid.pt32),
            
            tokenFiled.heightAnchor.constraint(equalToConstant: Grid.pt48),
            
            generateButton.heightAnchor.constraint(equalToConstant: Grid.pt48),
            
            removeCollectionView.heightAnchor.constraint(equalTo: tokenFiled.heightAnchor),
            removeCollectionView.widthAnchor.constraint(equalTo: removeCollectionView.widthAnchor),
            
            addButton.widthAnchor.constraint(equalTo: addButton.heightAnchor)
        ])
    }
}

// swiftlint: enable line_length
