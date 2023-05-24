//
//  LearnSettingsView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 07.05.2023.
//

import UIKit

protocol LearnSettingsViewDelegate: AnyObject {
    func question(selected: LearnSettings.Question)
    func language(selected: LearnSettings.Language)
    func answer(selected: LearnSettings.Answer)
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
            titleLabel,
            questionStackView,
            answerStackView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = Grid.pt32
        stackView.layoutMargins.bottom = safeAreaInsets.bottom
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
    
    // MARK: Question settings subviews
    
    private lazy var questionStackView: UIStackView = {
        let title = NSLocalizedString("Card type", comment: "Title")
        let titleLabel = LearnSettingsView.subviewTitleLabel(title)
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            languageStackView,
            wordStackView,
            imageStackView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = Grid.pt8
        return stackView
    }()
    private lazy var languageStackView: UIStackView = {
        let title = LearnSettings.Settings.language.name
        let titleLabel = LearnSettingsView.settingTitleLabel(title)
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            languageSegmentControl
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = Grid.pt16
        return stackView
    }()
    private var languageSegmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl()
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        LearnSettings.Language.allCases.enumerated().forEach { index, language in
            segmentControl.insertSegment(withTitle: language.name, at: index, animated: true)
        }
        segmentControl.tag = LearnSettings.Settings.language.rawValue
        return segmentControl
    }()
    private lazy var wordStackView: UIStackView = {
        let title = NSLocalizedString("Word", comment: "title")
        let titleLabel = LearnSettingsView.settingTitleLabel(title)
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            wordSwitch
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = Grid.pt16
        return stackView
    }()
    private var wordSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    private lazy var imageStackView: UIStackView = {
        let title = NSLocalizedString("Image", comment: "title")
        let titleLabel = LearnSettingsView.settingTitleLabel(title)
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            imageSwitch
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = Grid.pt16
        return stackView
    }()
    private var imageSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    // MARK: Answer settings subviews
    
    private lazy var answerStackView: UIStackView = {
        let title = NSLocalizedString("Answer type", comment: "Title")
        let titleLabel = LearnSettingsView.subviewTitleLabel(title)
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            answerSegmentStackView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = Grid.pt4
        return stackView
    }()
    private lazy var answerSegmentStackView: UIStackView = {
        let title = LearnSettings.Settings.answer.name
        let titleLabel = LearnSettingsView.settingTitleLabel(title)
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            answerSegmentControl
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = Grid.pt8
        return stackView
    }()
    private var answerSegmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl()
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        LearnSettings.Answer.allCases.enumerated().forEach { index, answer in
            segmentControl.insertSegment(with: answer.image, at: index, animated: true)
        }
        segmentControl.tag = LearnSettings.Settings.answer.rawValue
        return segmentControl
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
    
    // MARK: - Functions
    
    func configureUserSettings(
        question: LearnSettings.Question,
        answer: LearnSettings.Answer,
        language: LearnSettings.Language
    ) {
        setQuestion(question)
        setAnswer(answer)
        setLanguage(language)
    }
    
    func setQuestion(_ setting: LearnSettings.Question) {
        switch setting {
        case .word:
            wordSwitch.isOn = true
        case .image:
            wordSwitch.isOn = false
            imageSwitch.isOn = true
        case .wordImage:
            wordSwitch.isOn = true
            imageSwitch.isOn = true
        }
    }
    
    func setAnswer(_ setting: LearnSettings.Answer) {
        answerSegmentControl.selectedSegmentIndex = setting.rawValue
    }
    
    func setLanguage(_ setting: LearnSettings.Language) {
        languageSegmentControl.selectedSegmentIndex = setting.rawValue
    }
    
    @objc func switchDidChanged(sender: UISwitch) {
        checkLogicEmptyQuestion(sender)
        checkLogicImageAndSourceLanguage()
        if
            wordSwitch.isOn,
            imageSwitch.isOn {
            delegate?.question(selected: .wordImage)
        } else if
            wordSwitch.isOn,
            !imageSwitch.isOn {
            delegate?.question(selected: .word)
        } else if
            !wordSwitch.isOn,
            imageSwitch.isOn {
            delegate?.question(selected: .image)
        }
    }
    
    @objc func segmentControlDidChanged(sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        switch sender {
        case languageSegmentControl:
            checkLogicImageAndSourceLanguage()
            delegate?.language(selected: LearnSettings.Language.fromRawValue(index: selectedIndex))
        case answerSegmentControl:
            delegate?.answer(selected: LearnSettings.Answer.fromRawValue(index: selectedIndex))
        default:
            return
        }
    }
    
    // MARK: - Private functoions
    
    private func addActions() {
        let switchs = [wordSwitch, imageSwitch]
        switchs.forEach {
            $0.addTarget(
                self,
                action: #selector(switchDidChanged(sender:)),
                for: .valueChanged
            )
        }
        let segments = [languageSegmentControl, answerSegmentControl]
        segments.forEach {
            $0.addTarget(
                self,
                action: #selector(segmentControlDidChanged(sender:)),
                for: .valueChanged
            )
        }
    }
    
    /// The question must contain at least one element.
    private func checkLogicEmptyQuestion(_ sender: UISwitch) {
        let switchs = [wordSwitch, imageSwitch]
        if !wordSwitch.isOn,
           !imageSwitch.isOn {
            switchs.first(where: { $0 != sender })?.setOn(true, animated: true)
        }
    }
    
    /// The user cannot answer in their native language the question where only images
    private func checkLogicImageAndSourceLanguage() {
        if imageSwitch.isOn,
           !wordSwitch.isOn,
           languageSegmentControl.selectedSegmentIndex == LearnSettings.Language.target.rawValue {
            languageSegmentControl.selectedSegmentIndex = LearnSettings.Language.source.rawValue
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
        addActions()
        self.addSubview(container)
        container.addSubview(stackView)
    }
    
    // MARK: - Constraints
    
    // swiftlint:disable line_length
    private func setupConstraints() {
        let insetsContainer = UIEdgeInsets(top: Grid.pt16, left: Grid.pt16, bottom: Grid.pt16, right: Grid.pt16)
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: insetsContainer.top),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: insetsContainer.left),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -insetsContainer.right),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -insetsContainer.bottom)
        ])
    }
    // swiftlint:enable line_length
}
