//
//  PopUpListLanguageView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 17.04.2023.
//

import UIKit



class PopUpListLanguageView: UIView {
    
    //MARK: - Subviews
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .Theme.backgroundLightGray
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
        label.font = UIFont.Theme.title1
        label.text = NSLocalizedString("Языки", comment: "Title")
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LanguageCell.self, forCellReuseIdentifier: LanguageCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 50
        tableView.backgroundColor = .Theme.backgroundLightGray
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
    
    //MARK: - Methods
    
    @objc private func didTapBackroundView(sender: UIView) {
        self.removeFromSuperview()
        print(#function)
    }
    
    //MARK: - UI
    
    private func configureView() {
        configureGesture()
        self.backgroundColor = .white.withAlphaComponent(0.5)
        self.frame = UIScreen.main.bounds
    }
    
    private func configureSubviews() {
        self.addSubview(container)
        container.addSubview(titleLabel)
        container.addSubview(tableView)
    }
    
    private func configureGesture() {
        let tapBackground = UITapGestureRecognizer(target: self, action: #selector(didTapBackroundView(sender:)))
        tapBackground.delegate = self
        self.addGestureRecognizer(tapBackground)
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

extension PopUpListLanguageView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Language.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LanguageCell.identifier, for: indexPath) as? LanguageCell else { return UITableViewCell() }
        
        let language = Language.allCases[indexPath.row]
        cell.configure(language: language)
        
        //Replace code for get user study language here
        if language.code == "eu" {
            self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .bottom)
        }
        
        return cell
    }
}

extension PopUpListLanguageView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
        let selectedLanguage = Language.allCases[selectedIndexPath.item]
        
        //Change user study course here
        print("selected language \(selectedLanguage)")
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.removeFromSuperview()
        }
    }
}

extension PopUpListLanguageView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}
