//
//  LearnSettingsView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 07.05.2023.
//
// swiftlint: disable line_length

import UIKit

class LearnSettingsView: UIView {
    
    // MARK: - Properties
    
    // MARK: - Subviews
    
    let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGroupedBackground
        view.layer.cornerRadius = Grid.cr16
        return view
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(
            top: Grid.pt16,
            left: Grid.pt16,
            bottom: Grid.pt16,
            right: Grid.pt16
        )
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            labelStackView,
            settingsTableView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
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
        tableView.rowHeight = Grid.pt44
        return tableView
    }()
    
    // MARK: - Constraction
    
    init(settingsManager: LearnSettingsManager) {
        super.init(frame: .zero)
        configureSettingsTableView(settingsManager: settingsManager)
        configureView()
        configureSubviews()
        setupConstraints()
        addObserverKeyboard()
        configureGesture()
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
    
    
    // MARK: - Functions
    
    private func configureSettingsTableView(settingsManager: LearnSettingsManager) {
        settingsTableView.settingsManager = settingsManager
        settingsTableView.reloadData()
    }
    
    // MARK: - Private functoions
    
    // MARK: - Keyboard observer
    
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
        
        UIView.animate(withDuration: Grid.factor25) {
            self.setNeedsUpdateConstraints()
            self.layoutIfNeeded()
        }
    }
    
    private func configureGesture() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard(gesture:))
        )
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(gesture: UIGestureRecognizer) {
        let cells = settingsTableView.visibleCells.filter({
            if ($0 as? SwitchValueCell) != nil {
                return true
            } else {
                return false
            }
        })
        cells.forEach { cell in
            if let cell = cell as? SwitchValueCell {
                cell.textFiled.resignFirstResponder()
            }
        }
    }
    
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
        container.addSubview(scrollView)
        scrollView.addSubview(stackView)
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        let settingsTableViewHeight = settingsTableView.contentSize.height + settingsTableView.rectForHeader(inSection: .zero).height
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            scrollView.topAnchor.constraint(equalTo: container.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            scrollView.bottomAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor),
            scrollView.heightAnchor.constraint(equalTo: stackView.heightAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            settingsTableView.widthAnchor.constraint(equalTo: container.widthAnchor),
            settingsTableView.heightAnchor.constraint(equalToConstant: settingsTableViewHeight)
        ])
    }
}

extension LearnSettingsView: SettingsViewDelegate {
    
}

// swiftlint: enable line_length
