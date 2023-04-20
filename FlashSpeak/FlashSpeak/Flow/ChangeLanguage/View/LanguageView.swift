//
//  ChangeLanguageView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 17.04.2023.
//

import UIKit



class LanguageView: UIView {
    
    //MARK: - Subviews
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backgroundLightGray
        view.layer.cornerRadius = 16
        view.layer.shadowRadius = 32
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = .init(width: 0, height: 4)
        view.layer.shadowOpacity = 0.25
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.title1
        label.text = NSLocalizedString("Языки", comment: "Title")
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(LanguageCell.self, forCellReuseIdentifier: LanguageCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 50
        tableView.backgroundColor = .backgroundLightGray
        return tableView
    }()
    
    //MARK: - Init
    
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
    
    //MARK: - UI
    
    private func configureView() {
        self.backgroundColor = .white.withAlphaComponent(0.5)
        self.frame = UIScreen.main.bounds
    }
    
    private func configureSubviews() {
        self.addSubview(container)
        container.addSubview(titleLabel)
        container.addSubview(tableView)
    }
    
    
    
    //MARK: - Constraints
    
    private func setupConstraints() {
        let insetsContainer = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        NSLayoutConstraint.activate([
            container.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            container.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85),
            container.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: insetsContainer.top),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: insetsContainer.left),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -insetsContainer.right),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: insetsContainer.top),
            tableView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: insetsContainer.left),
            tableView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -insetsContainer.right),
            tableView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -insetsContainer.bottom)
        ])
    }
    
}
