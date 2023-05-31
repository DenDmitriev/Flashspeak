//
//  WelcomeView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 28.04.2023.
//

import UIKit

class WelcomeView: UIView {
    
    // MARK: - Subviews
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .titleBold1
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .title3
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let sourcelanguageLabel: UILabel = languageLabel()
    private let targetlanguageLabel: UILabel = languageLabel()
    let sourcelanguageButton: UIButton = languageButton()
    let targetlanguageButton: UIButton = languageButton()
    
    let eventButton: UIButton = {
        let button = UIButton(configuration: UIButton.Configuration.appFilled())
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel,
            languageStackView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Grid.pt16
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(
            top: Grid.pt16,
            left: Grid.pt16,
            bottom: Grid.pt16,
            right: Grid.pt16
        )
        return stackView
    }()
    
    private lazy var languageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            sourcelanguageStackView,
            targetlanguageStackView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Grid.pt16
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var sourcelanguageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            sourcelanguageLabel,
            sourcelanguageButton
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Grid.pt16
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var targetlanguageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            targetlanguageLabel,
            targetlanguageButton
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Grid.pt16
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: - Constraction
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        configureTitles()
        addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        addSubview(eventButton)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Functions
    
    func configureButtons(type: Language.LanguageType, language: Language) {
        switch type {
        case .source:
            configureContentButton(sourcelanguageButton, language)
        case .target:
            configureContentButton(targetlanguageButton, language)
        }
    }
    
    // MARK: - Private functions
    
    private static func languageLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .title3
        label.textAlignment = .center
        return label
    }
    
    private static func languageButton() -> UIButton {
        var configuration = UIButton.Configuration.borderedTinted()
        configuration.cornerStyle = .small
        configuration.imagePlacement = .bottom
        configuration.imagePadding = Grid.pt8
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: Grid.pt8,
            leading: Grid.pt16,
            bottom: Grid.pt16,
            trailing: Grid.pt16
        )
        let button = UIButton(configuration: configuration)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.layer.cornerRadius = Grid.cr8
        button.imageView?.layer.masksToBounds = true
        return button
    }
    
    private func configureTitles() {
        let title = NSLocalizedString("Welcome", comment: "Title")
        let subtitle = NSLocalizedString(
            "Before we start, we need to know what language you will be learning.",
            comment: "Description"
        )
        let sourcelanguageTitle = NSLocalizedString("Your native language:", comment: "Title")
        let targetlanguageTitle = NSLocalizedString("Language of study:", comment: "Title")
        let eventButtonTitle = NSLocalizedString("Begin", comment: "Button")
        
        titleLabel.text = title
        subtitleLabel.text = subtitle
        sourcelanguageLabel.text = sourcelanguageTitle
        targetlanguageLabel.text = targetlanguageTitle
        eventButton.setTitle(eventButtonTitle, for: .normal)
    }
    
    private func configureContentButton(_ button: UIButton, _ source: Language) {
        let title = source.description
        let image = UIImage(named: source.code)
        button.configurationUpdateHandler = { button in
            var config = button.configuration
            config?.image = image
            config?.title = title
            button.configuration = config
        }
    }
    
    // MARK: - Constraints
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: eventButton.topAnchor, constant: -Grid.pt16),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor),
            
            eventButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Grid.pt16),
            eventButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Grid.pt16),
            eventButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Grid.pt16),
            eventButton.heightAnchor.constraint(equalToConstant: Grid.pt44)
        ])
    }

}
