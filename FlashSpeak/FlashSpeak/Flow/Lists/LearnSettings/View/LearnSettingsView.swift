//
//  LearnSettingsView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 07.05.2023.
//

import UIKit

protocol LearnSettingsViewDelegate: AnyObject {
    func settingsChanged(_ settings: LearnSettings)
}

class LearnSettingsView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: LearnSettingsViewDelegate?
    
    // MARK: - Subviews
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .tertiarySystemBackground
        view.layer.cornerRadius = Grid.cr16
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = Grid.pt32
        stackView.layoutMargins.bottom = safeAreaInsets.bottom
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(
            top: Grid.pt16,
            left: Grid.pt16,
            bottom: Grid.pt16,
            right: Grid.pt16
        )
        return stackView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = UIFont.titleBold2
        label.text = NSLocalizedString("Study Settings", comment: "Title")
        label.numberOfLines = 2
        return label
    }()
    
    lazy var settingsTableView: SettingsTableView = {
        let tableView = SettingsTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.viewDelegate = self
        return tableView
    }()
    
    // MARK: - Constraction
    
    init(learnSettings: LearnSettings, delegate: LearnSettingsViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        configureSettingsTableView(learnSettings: learnSettings)
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
    
    // MARK: - Functions
    
    private func configureSettingsTableView(learnSettings: LearnSettings) {
        settingsTableView.learnSettings = learnSettings
        settingsTableView.reloadData()
    }
    
    // MARK: - Private functoions
    
    // MARK: - UI
    
    private static func subviewTitleLabel(_ title: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = UIFont.titleBold3
        label.text = title
        label.numberOfLines = 2
        return label
    }
    private static func settingTitleLabel(_ title: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .subhead
        label.text = title
        return label
    }
    private static func settingDescriptionLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .regular
        label.text = text
        return label
    }
    
    private func configureView() {
        
    }
    
    private func configureSubviews() {
        self.addSubview(container)
        container.addSubview(stackView)
        container.addSubview(settingsTableView)
    }
    
    // MARK: - Constraints
    
    // swiftlint:disable line_length
    private func setupConstraints() {
        let settingsTableViewHeight = settingsTableView.contentSize.height + settingsTableView.rectForHeader(inSection: .zero).height
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: container.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            settingsTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            settingsTableView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            settingsTableView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            settingsTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            settingsTableView.heightAnchor.constraint(equalToConstant: settingsTableViewHeight)
        ])
    }
    // swiftlint:enable line_length
}

extension LearnSettingsView: SettingsViewDelegate {
    func settingsChanged(_ settings: LearnSettings) {
        delegate?.settingsChanged(settings)
    }
}
