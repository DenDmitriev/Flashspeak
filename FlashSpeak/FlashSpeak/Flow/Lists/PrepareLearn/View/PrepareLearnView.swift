//
//  PrepareLearnView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 25.05.2023.
//
// swiftlint: disable line_length

import UIKit

protocol PrepareLearnViewDelegate: AnyObject {
    func settingsChanged(_ settings: LearnSettings)
}

class PrepareLearnView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: PrepareLearnViewDelegate?
    
    // MARK: - Private properties
    
    private var contentHeightAnchor = NSLayoutConstraint()
    
    // MARK: - Subviews
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .tertiarySystemBackground
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.autoresizingMask = .flexibleHeight
        scrollView.layer.cornerRadius = Grid.cr12
        return scrollView
    }()

    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            listStackView,
            resultStackView,
            learnStackView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = Grid.pt16
        stackView.axis = .vertical
        stackView.layoutMargins = .init(
            top: Grid.pt16,
            left: Grid.pt16,
            bottom: (Grid.pt16 + safeAreaInsets.bottom),
            right: Grid.pt16
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .titleBold2
        return label
    }()
    
    // MARK: Result Subviews
    
    private lazy var resultStackView: UIStackView = {
        let title = NSLocalizedString("Результаты", comment: "Title")
        return groupStackView(title: title, arrangedSubviews: [
            learnResultView,
            lookStatisticButton
        ])
    }()
    
    private var learnResultView: LearnResultView = {
        let view = LearnResultView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var lookStatisticButton: UIButton = {
        let title = NSLocalizedString("Смотреть статистику", comment: "button")
        let button = PrepareLearnView.button(title: title)
        button.configuration = .appGray()
        return button
    }()
    
    // MARK: List Subviews
    
    private lazy var listStackView: UIStackView = {
        let title = NSLocalizedString("Список", comment: "title")
        return groupStackView(title: title, arrangedSubviews: [
            listLabel,
            lookCardsButton
        ])
    }()
    
    private var listLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var lookCardsButton: UIButton = {
        let title = NSLocalizedString("Смотреть карточки", comment: "button")
        let button = PrepareLearnView.button(title: title)
        button.configuration = .appGray()
        return button
    }()
    
    // MARK: Learn Subviews
    
    private lazy var learnStackView: UIStackView = {
        let title = NSLocalizedString("Обучение", comment: "title")
        return groupStackView(title: title, arrangedSubviews: [
            learnButtonStackView,
            settingsTableView
        ])
    }()
    
    private lazy var learnButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            settingsButton,
            learnButton
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = Grid.pt8
        stackView.axis = .horizontal
        return stackView
    }()
    
    var settingsButton: UIButton = {
        let title = NSLocalizedString("Настройка режима", comment: "button")
        let image = UIImage(systemName: "gearshape.fill")
        let button = PrepareLearnView.button(title: nil)
        button.configuration = .appGray()
        button.setImage(image, for: .normal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return button
    }()
    
    var learnButton: UIButton = {
        let title = NSLocalizedString("Начать обучение", comment: "button")
        let button = PrepareLearnView.button(title: title)
        return button
    }()
    
    lazy var settingsTableView: SettingsTableView = {
        let tableView = SettingsTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.isHidden = true
        tableView.viewDelegate = self
        return tableView
    }()
    
    // MARK: - Constraction
    
    init(learnSettings: LearnSettings, delegate: PrepareLearnViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        configureSettingsTableView(learnSettings: learnSettings)
        configureSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let emptyHeight = frame.height - scrollView.contentSize.height
        if emptyHeight > .zero {
            self.contentHeightAnchor.constant = emptyHeight
        } else {
            self.contentHeightAnchor.constant = .zero
        }
    }
    
    // MARK: - Functions
    
    func configure(learnings: [Learn], wordsCount: Int) {
        learnResultView.setResult(learnings: learnings, wordsCount: wordsCount)
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setList(wordsCount: Int) {
        let text = NSLocalizedString("Колличество слов", comment: "text")
        listLabel.text = text + " - " + "\(wordsCount)"
    }
    
    // MARK: - Private Functions
    
    private func groupStackView(title: String, arrangedSubviews: [UIView]) -> UIStackView {
        let label = UILabel()
        label.text = title
        label.font = .titleBold3
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.insertArrangedSubview(label, at: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = Grid.pt16
        stackView.axis = .vertical
        stackView.layoutMargins = .init(top: Grid.pt16, left: Grid.pt16, bottom: Grid.pt16, right: Grid.pt16)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layer.cornerRadius = Grid.cr12
        stackView.layer.masksToBounds = true
        stackView.backgroundColor = .secondarySystemBackground
        return stackView
    }
    
    private static func button(title: String?) -> UIButton {
        let configure = UIButton.Configuration.appFilled()
        let button = UIButton(configuration: configure)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        return button
    }
    
    private func configureSettingsTableView(learnSettings: LearnSettings) {
        settingsTableView.learnSettings = learnSettings
        settingsTableView.reloadData()
    }
    
    // MARK: - UI
    
    private func configureSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(contentStackView)
    }
    
    private func setupConstraints() {
        contentHeightAnchor = scrollView.topAnchor.constraint(equalTo: topAnchor)
        let settingsTableViewHeight = settingsTableView.contentSize.height + settingsTableView.rectForHeader(inSection: .zero).height
        NSLayoutConstraint.activate([
            
            contentHeightAnchor,
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: widthAnchor),
            
            settingsTableView.heightAnchor.constraint(equalToConstant: settingsTableViewHeight)
        ])
    }
}

extension PrepareLearnView: SettingsViewDelegate {
    func settingsChanged(_ settings: LearnSettings) {
        delegate?.settingsChanged(settings)
    }
}

// swiftlint: enable line_length
