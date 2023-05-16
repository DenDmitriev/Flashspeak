//
//  ListMakerView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 21.04.2023.
//

import UIKit

class ListMakerView: UIView {
    
    // MARK: - Propeties
    
    var style: GradientStyle?
    var tabBarHeight: CGFloat?
    
    // MARK: - Subviews
    
    // MARK: Main subview
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            tokenStackView,
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
            tokenCollectionView,
            removeCollectionView
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
    
    private lazy var fieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            tokenFiled,
            addButton
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = Grid.pt8
        return stackView
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
    
    // MARK: Action subviews
    
    let generateButton: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .appFilled()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Создать карточки", comment: "Button"), for: .normal)
        button.tintColor = .tint
        button.layer.cornerRadius = Grid.cr16
        button.isEnabled = false
        return button
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.configuration = .appFilled()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .tint
        button.isEnabled = false
        return button
    }()
    
    // MARK: Spinner subviews
    
    var activityIndicator: ActivityIndicatorView = {
        let view = ActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    
    func spinner(isActive: Bool, title: String? = nil) {
        activityIndicator.isHidden = !isActive
        switch isActive {
        case true:
            activityIndicator.setTitle(title ?? "")
            activityIndicator.start()
        case false:
            activityIndicator.stop()
        }
    }
    
    func generateButton(isEnabled: Bool) {
        generateButton.isEnabled = isEnabled
    }
    
    func addButton(isEnabled: Bool) {
        addButton.isEnabled = isEnabled
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
    
    private func configureSubviews() {
        addSubview(contentStackView)
        addSubview(activityIndicator)
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
            
            removeCollectionView.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: Grid.factor75)
        ])
    }
}
