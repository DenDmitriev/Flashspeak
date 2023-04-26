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
        view.backgroundColor = .backgroundLightGray
        view.layer.cornerRadius = Grid.cr16
        view.layer.shadowRadius = 32
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = .init(width: 0, height: 4)
        view.layer.shadowOpacity = 0.25
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.title1
        label.text = NSLocalizedString("Новый список", comment: "Title")
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            // By row lines
            titleLabel, // Title view
            titleFiled, // Title list
            colorLabel, colorCollectionView, // Card color
            imageStackView, // Image flag
            doneButton // Action
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()
    
    let titleFiled: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = NSLocalizedString("Введите название", comment: "Placeholder")
        textField.font = UIFont.title3
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let colorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.title3
        label.text = NSLocalizedString("Цвет карточек", comment: "Title")
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
    
    private lazy var imageStackView: UIStackView = {
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .black
        titleLabel.font = UIFont.title3
        titleLabel.text = NSLocalizedString("Изображения", comment: "Title")
        
        let captionLabel = UILabel()
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.textColor = .black
        captionLabel.font = UIFont.caption2
        captionLabel.text = NSLocalizedString("Включить изображения в карточках", comment: "Title")
        
        let stackLabelsView = UIStackView(arrangedSubviews: [titleLabel, captionLabel])
        stackLabelsView.translatesAutoresizingMaskIntoConstraints = false
        stackLabelsView.axis = .vertical
        stackLabelsView.spacing = 0
        stackLabelsView.alignment = .leading
        stackLabelsView.distribution = .fillProportionally
        
        let stackView = UIStackView(arrangedSubviews: [stackLabelsView, switchImageOn])
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
        
        configureView()
        configureSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - UI
    
    private func configureView() {
        self.backgroundColor = .white.withAlphaComponent(0.5)
        self.frame = UIScreen.main.bounds
    }
    
    private func configureSubviews() {
        self.addSubview(container)
        configureColorCollectonView()
        container.addSubview(stackView)
    }
    
    private func configureColorCollectonView() {
        colorCollectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
    }
    
    // MARK: - Constraints
    
    // swiftlint:disable line_length
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            container.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            container.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: Grid.factor85),
            
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: insetsContainer.top),
            stackView.leadingAnchor.constraint(
                equalTo: container.leadingAnchor,
                constant: insetsContainer.left
            ),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -insetsContainer.right),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -insetsContainer.bottom),
            
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
