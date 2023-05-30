//
//  AddNewWordView.swift
//  FlashSpeak
//
//  Created by Anastasia Losikova on 28.05.2023.
//

import UIKit

class AddNewWordView: UIView {
    
    let button: UIButton = {
        var configuration: UIButton.Configuration = .appFilled()
        configuration.imagePadding = Grid.pt4
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        let title = NSLocalizedString("Save", comment: "Button")
        button.setTitle(title, for: .normal)
        return button
    }()
    
    // MARK: Private properties
    
    private lazy var wordStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            newWordField,
            button
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutMargins = UIEdgeInsets(
            top: Grid.pt64,
            left: Grid.pt8,
            bottom: Grid.pt32,
            right: Grid.pt8
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.alignment = .fill
        stackView.spacing = Grid.pt8
        stackView.axis = .vertical
        stackView.layer.cornerRadius = Grid.cr8
        stackView.layer.masksToBounds = true
        return stackView
    }()

    private let newWordField: UITextField = {
        let textFiled = UITextField()
        textFiled.borderStyle = .roundedRect
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        textFiled.placeholder = NSLocalizedString("Enter word", comment: "Placeholder")
        textFiled.font = .titleBold1
        textFiled.textAlignment = .center
        textFiled.layer.cornerRadius = Grid.cr12
        textFiled.layer.masksToBounds = true
        return textFiled
    }()
    
    private let style: GradientStyle
    
    // MARK: Init
    
    init(style: GradientStyle) {
        self.style = style
        super.init(frame: .zero)
        setupView()
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getText() -> String? {
        newWordField.text?
            .lowercased()
            .cleanText()
    }
    
    // MARK: Private functions
    
    private func setupView() {
        backgroundColor = .systemBackground
        addSubview(wordStackView)
        
        NSLayoutConstraint.activate([
            wordStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Grid.pt16),
            wordStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Grid.pt16),
            wordStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            button.heightAnchor.constraint(equalTo: newWordField.heightAnchor)
        ])
    }
    
    private func setupAppearance() {
        wordStackView.backgroundColor = UIColor.color(by: style)
    }
}
