//
//  ChangeLanguageView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 17.04.2023.
//

import UIKit

class LanguageView: UIView {
    
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
            titleLabel,
            descriptionLabel,
            tableView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = Grid.pt8
        stackView.layoutMargins.bottom = safeAreaInsets.bottom
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .titleBold1
        label.text = NSLocalizedString("Languages", comment: "Title")
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .subhead
        label.text = NSLocalizedString("Select a language below", comment: "Title")
        return label
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(LanguageCell.self, forCellReuseIdentifier: LanguageCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = Grid.pt48
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    // MARK: - Constraction
    
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
    
    // MARK: - Functins
    
    func setTitle(_ title: String?, description: String?) {
        if let title = title {
            titleLabel.text = title
        }
        if let description = description {
            descriptionLabel.text = description
        }
    }
    
    // MARK: - UI
    
    private func configureView() {
        
    }
    
    private func configureSubviews() {
        self.addSubview(container)
        container.addSubview(stackView)
    }
    
    // MARK: - Constraints
    
    // swiftlint:disable line_length
    
    private func setupConstraints() {
        let insetsContainer = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        let rowCount = CGFloat(Language.allCases.count)
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: insetsContainer.top),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: insetsContainer.left),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -insetsContainer.right),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -insetsContainer.bottom),
            
            tableView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            tableView.heightAnchor.constraint(equalToConstant: tableView.rowHeight * rowCount)
        ])
    }
    
    // swiftlint:enable line_length
    
}
