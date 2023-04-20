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
        view.layer.cornerRadius = Grid.cr16
        view.layer.shadowRadius = Grid.pt32
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = .init(width: 0, height: Grid.pt4)
        view.layer.shadowOpacity = Float(Grid.factor25)
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            tableView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = Grid.pt8
        return stackView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.title1
        label.text = NSLocalizedString("Языки", comment: "Title")
        return label
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(LanguageCell.self, forCellReuseIdentifier: LanguageCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = Grid.pt48
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
//        container.addSubview(titleLabel)
//        container.addSubview(tableView)
        container.addSubview(stackView)
    }
    
    
    
    //MARK: - Constraints
    
    private func setupConstraints() {
        let insetsContainer = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        let rowCount = CGFloat(Language.allCases.count)
        
        NSLayoutConstraint.activate([
            container.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            container.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: Grid.factor85),
            
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: insetsContainer.top),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: insetsContainer.left),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -insetsContainer.right),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -insetsContainer.bottom),
            
            tableView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            tableView.heightAnchor.constraint(equalToConstant: tableView.rowHeight * rowCount)
        ])
    }
    
}
