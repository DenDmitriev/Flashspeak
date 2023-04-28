//
//  SettingsButton.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 27.04.2023.
//

import UIKit

protocol SettingableButton {
    func setSettings(settings: LearnSettings)
}

final class SettingsButton: UIButton {
    
    // MARK: - Subviews
    
    private var questionView = UIImageView()
    private var answerView = UIImageView()
    private let languageView = UIImageView()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            questionView,
            answerView,
            languageView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = Grid.pt4
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.layer.cornerRadius = Grid.cr8
        stackView.layer.masksToBounds = true
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: Grid.pt6,
            leading: Grid.pt4,
            bottom: Grid.pt6,
            trailing: Grid.pt8
        )
        stackView.isUserInteractionEnabled = false
        return stackView
    }()
    
    // MARK: - Constractions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    // MARK: - Private functions
    
    private func configure() {
        var configuration = UIButton.Configuration.gray()
        configuration.baseBackgroundColor = .tint
        configuration.cornerStyle = .medium
        configuration.buttonSize = .large
        self.configuration = configuration
        
        stackView.arrangedSubviews.forEach { imageView in
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .white
        }
        
        addSubview(stackView)
        configureConstraints()
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension SettingsButton: SettingableButton {
    
    // MARK: - Functions
    
    func setSettings(settings: LearnSettings) {
        let questionImage: UIImage?
        switch settings.question {
        case .word:
            questionImage = UIImage(systemName: "character")
        case .image:
            questionImage = UIImage(systemName: "photo")
        case .wordImage:
            questionImage = UIImage(systemName: "doc.richtext.fill")
        }
        questionView.image = questionImage
        
        let answerImage: UIImage?
        switch settings.answer {
        case .test:
            answerImage = UIImage(systemName: "square.grid.2x2.fill")
        case .keyboard:
            answerImage = UIImage(systemName: "keyboard.fill")
        }
        answerView.image = answerImage
        
        let languageImage: UIImage?
        switch settings.language {
        case .source:
            languageImage = UIImage(named: "lang.icon.ru")
        case .target:
            languageImage = UIImage(named: "lang.icon.en")
        }
        languageView.image = languageImage
    }
}
