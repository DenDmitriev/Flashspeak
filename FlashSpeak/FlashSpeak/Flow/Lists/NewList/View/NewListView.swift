//
//  NewListView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 17.04.2023.
//
// swiftlint:disable line_length

import UIKit

class NewListView: UIView {
    
    private var heightColorCollectionConstraint = NSLayoutConstraint()
    
    // MARK: - Subviews
    
    let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .tertiarySystemBackground
        view.layer.cornerRadius = Grid.cr16
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleFiled, // Title list
            colorStackView, // Card color
            imageStackView, // Image flag
            doneButton // Action
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Grid.pt32
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(
            top: Grid.pt16,
            left: Grid.pt16,
            bottom: .zero,
            right: Grid.pt16
        )
        return stackView
    }()
    
    // MARK: Name list subviews
    
    let titleFiled: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = NSLocalizedString("New List", comment: "Placeholder")
        textField.font = UIFont.titleBold2
        textField.layer.cornerRadius = Grid.cr12
        textField.leftViewMode = .always
        let leftView = UIView(frame: CGRect(x: .zero, y: .zero, width: Grid.pt12, height: .zero))
        textField.leftView = leftView
        textField.backgroundColor = .secondarySystemBackground
        return textField
    }()
    
    // MARK: Style list subviews
    
    private lazy var colorStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            colorLabel,
            colorCollectionView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Grid.pt12
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var colorLabel: UILabel = {
        let title = NSLocalizedString("Word List Color", comment: "")
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        return label
    }()
    
    
    let colorCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: Image list subviews
    
    private lazy var imageLabel: UILabel = {
        let title = NSLocalizedString("Enable images in cards", comment: "Title")
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.numberOfLines = .zero
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private lazy var imageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            imageLabel,
            switchImageOn
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = Grid.pt16
        stackView.alignment = .fill
//        stackView.distribution = .fill
        
        return stackView
    }()
    
    let switchImageOn: UISwitch = {
        let swithc = UISwitch()
        swithc.translatesAutoresizingMaskIntoConstraints = false
        swithc.tintColor = .tint
        swithc.isOn = true
        return swithc
    }()
    
    // MARK: Action list subviews
    
    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .appFilled()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Create List", comment: "Button"), for: .normal)
        button.tintColor = .tint
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureGesture()
        configureView()
        configureSubviews()
        setupConstraints()
        addObserverKeyboard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heightColorCollectionConstraint.constant = colorCollectionView.collectionViewLayout.collectionViewContentSize.height
    }
    
    // MARK: - Private Functions
    
    private func captionLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .subhead
        label.text = text
        return label
    }
    
    private func titleLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .titleBold3
        label.text = text
        return label
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
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            stackView.layoutMargins.bottom = .zero
        } else {
            let keyboardScreenEndFrame = keyboardValue.cgRectValue
            let keyboardViewEndFrame = convert(keyboardScreenEndFrame, from: window)
            stackView.layoutMargins.bottom = keyboardViewEndFrame.height
        }
        
        UIView.animate(withDuration: Grid.factor25) {
            self.setNeedsUpdateConstraints()
            self.layoutIfNeeded()
        }
    }
    
    @objc func dismissKeyboard(gesture: UIGestureRecognizer) {
        titleFiled.resignFirstResponder()
    }
    
    // MARK: - UI
    
    private func configureView() {
    }
    
    private func configureSubviews() {
        self.addSubview(container)
        configureColorCollectonView()
        container.addSubview(stackView)
    }
    
    private func configureColorCollectonView() {
        colorCollectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
    }
    
    private func configureGesture() {
        let tab = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard(gesture:))
        )
        tab.cancelsTouchesInView = false
        container.addGestureRecognizer(tab)
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        heightColorCollectionConstraint = colorCollectionView.heightAnchor.constraint(equalToConstant: .zero)
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: container.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -safeAreaInsets.bottom),
            
            titleFiled.heightAnchor.constraint(equalToConstant: Grid.pt48),
            doneButton.heightAnchor.constraint(equalToConstant: Grid.pt48),
            
            colorCollectionView.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -(stackView.layoutMargins.left + stackView.layoutMargins.right)),
            heightColorCollectionConstraint
        ])
    }
    
}

// swiftlint:enable line_length
