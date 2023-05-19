//
//  NewListView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 17.04.2023.
//

import UIKit

class NewListView: UIView {
    
    let insetsContainer = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
    // MARK: - Subviews
    
    let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .tertiarySystemBackground
        view.layer.cornerRadius = Grid.cr16
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = UIFont.titleBold1
        label.text = NSLocalizedString("Новый список", comment: "Title")
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            // By row lines
            titleLabel, // Title view
            titleFiled, // Title list
            colorLabelStack, colorCollectionView, // Card color
            imageStackView, // Image flag
            doneButton // Action
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins.bottom = safeAreaInsets.bottom
        return stackView
    }()
    
    // MARK: Name list subviews
    
    let titleFiled: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = NSLocalizedString("Введите название", comment: "Placeholder")
        textField.font = UIFont.titleBold3
        textField.layer.cornerRadius = Grid.cr12
        textField.leftViewMode = .always
        let leftView = UIView(frame: CGRect(x: .zero, y: .zero, width: Grid.pt12, height: .zero))
        textField.leftView = leftView
        textField.backgroundColor = .secondarySystemBackground
        return textField
    }()
    
    // MARK: Style list subviews
    
    private lazy var colorLabelStack: UIStackView = {
        let title = NSLocalizedString("Стиль", comment: "")
        let caption = NSLocalizedString("Цвет списка слов", comment: "")
        return labelStackView(title: title, caption: caption)
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
    
    private lazy var imageLabelStack: UIStackView = {
        let title = NSLocalizedString("Изображения", comment: "Title")
        let caption = NSLocalizedString("Включить изображения в карточках", comment: "Title")
        return labelStackView(title: title, caption: caption)
    }()
    
    private lazy var imageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            imageLabelStack,
            switchImageOn
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .center
        stackView.distribution = .fill
        
        return stackView
    }()
    
    let switchImageOn: UISwitch = {
        let swithc = UISwitch()
        swithc.translatesAutoresizingMaskIntoConstraints = false
        swithc.tintColor = .tint
        swithc.isOn = true
        swithc.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return swithc
    }()
    
    // MARK: Action list subviews
    
    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .appFilled()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Создать список", comment: "Button"), for: .normal)
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
    }
    
    // MARK: - Private Functions
    
    private func labelStackView(title: String, caption: String) -> UIStackView {
        let titleLabel = titleLabel(title)
        let captionLabel = captionLabel(caption)
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            captionLabel
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }
    
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
        
        UIView.animate(withDuration: 0.3) {
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
    
    // swiftlint:disable line_length
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: insetsContainer.top),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: insetsContainer.left),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -insetsContainer.right),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            
            titleFiled.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1),
            imageStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1),
            doneButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1),
            titleFiled.heightAnchor.constraint(equalToConstant: Grid.pt48),
            doneButton.heightAnchor.constraint(equalToConstant: Grid.pt48),
            
            colorCollectionView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1),
            colorCollectionView.heightAnchor.constraint(equalToConstant: Grid.pt48)
        ])
    }
    
    // swiftlint:enable line_length
    
}
