//
//  ResultView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 07.05.2023.
//
// swiftlint:disable line_length

import UIKit

class ResultView: UIView {
    
    // MARK: - Properties
    
    private var heightResultTableView = NSLayoutConstraint()
    private var heightMistakeTableView = NSLayoutConstraint()
    
    // MARK: - Subviews
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            resultStackView,
            mistakesStackView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = Grid.pt16
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(
            top: .zero,
            left: Grid.pt16,
            bottom: Grid.pt16 + safeAreaInsets.bottom,
            right: Grid.pt16
        )
        return stackView
    }()
    
    // MARK: Result Subviews
    
    private lazy var resultStackView: UIStackView = {
        return ResultView.groupStackView(arrangedSubviews: [
            resultsLabel,
            resultTableView
        ])
    }()
    
    private let resultsLabel: UILabel = {
        let text = NSLocalizedString("Statistic", comment: "title")
        return ResultView.titleLabel(title: text)
    }()
    
    private let resultTableView: UITableView & ResultTableViewProtocol = {
        let tableView = ResultTableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.rowHeight = Grid.pt44
        return tableView
    }()
    
    // MARK: Mistakes Subviews
    
    private lazy var mistakesStackView: UIStackView = {
        return ResultView.groupStackView(arrangedSubviews: [
            mistakesLabel,
            mistakeTableView
        ])
    }()
    
    private let mistakesLabel: UILabel = {
        let text = NSLocalizedString("Mistakes", comment: "title")
        return ResultView.titleLabel(title: text)
    }()
    
    private let mistakeTableView: UITableView & MistakeTableViewProtocol = {
        let tableView = MistakeTableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.rowHeight = Grid.pt44
        return tableView
    }()
    
    // MARK: Learn Subviews
    
    private lazy var repeatButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            settingsButton,
            repeatButton
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = Grid.pt8
        stackView.axis = .horizontal
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(
            top: Grid.pt16,
            left: Grid.pt16,
            bottom: Grid.pt16,
            right: Grid.pt16
        )
        return stackView
    }()
    
    let repeatButton: UIButton = {
        let title = NSLocalizedString("Repeat", comment: "title")
        let button = ResultView.button(title: title)
        return button
    }()
    
    var settingsButton: UIButton = {
        let title = NSLocalizedString("Mode setting", comment: "button")
        let image = UIImage(systemName: "gearshape.fill")
        let button = ResultView.button(title: nil)
        button.configuration = .appFilled()
        button.setImage(image, for: .normal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return button
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
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Functions
    
    func updateResults(viewModels: [ResultViewModel]) {
        resultTableView.resultViewModels.append(contentsOf: viewModels)
        resultTableView.reloadData()
        resultTableView.layoutIfNeeded()
        heightResultTableView.constant = resultTableView.contentSize.height
    }
    
    func updateMistakes(viewModels: [WordCellModel]) {
        mistakeTableView.mistakeViewModels.append(contentsOf: viewModels)
        mistakeTableView.reloadData()
        mistakeTableView.layoutIfNeeded()
        heightMistakeTableView.constant = mistakeTableView.contentSize.height
    }
    
    // MARK: - Private functions
    
    private static func titleLabel(title: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.font = .titleBold2
        return label
    }
    
    private static func groupStackView(arrangedSubviews: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = Grid.pt16
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: Grid.pt16, left: Grid.pt16, bottom: Grid.pt16, right: Grid.pt16)
        stackView.backgroundColor = .systemBackground
        stackView.layer.cornerRadius = Grid.cr12
        return stackView
    }
    
    private static func button(title: String?) -> UIButton {
        var configure = UIButton.Configuration.appFilled()
        configure.titleLineBreakMode = .byTruncatingTail
        let button = UIButton(configuration: configure)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.titleLabel?.minimumScaleFactor = 0.5
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }
    
    // MARK: - UI
    
    private func configureView() {
        backgroundColor = .secondarySystemBackground
    }
    
    private func configureSubviews() {
        addSubview(scrollView)
        addSubview(repeatButtonStackView)
        scrollView.addSubview(contentStackView)
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        heightResultTableView = resultTableView.heightAnchor.constraint(equalToConstant: .zero)
        heightMistakeTableView = mistakeTableView.heightAnchor.constraint(equalToConstant: .zero)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: repeatButtonStackView.topAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            
            heightResultTableView,
            heightMistakeTableView,
            
            repeatButtonStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            repeatButtonStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            repeatButtonStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            repeatButton.heightAnchor.constraint(equalToConstant: Grid.pt48)
        ])
    }
}

// swiftlint:enable line_length
