//
//  LearnSettingsView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 07.05.2023.
//

import UIKit

protocol LearnSettingsViewDelegate: AnyObject {
    func segmentControlDidChanged(setting: LearnSettings.Settings, index: Int)
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
        stackView.spacing = Grid.pt16
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
    
    private var questionSegmentControl: UISegmentedControl = {
        let segmentControll = settingSegmentControl()
        segmentControll.tag = LearnSettings.Settings.question.rawValue
        return segmentControll
    }()
    
    private var answerSegmentControl: UISegmentedControl = {
        let segmentControll = settingSegmentControl()
        segmentControll.tag = LearnSettings.Settings.answer.rawValue
        return segmentControll
    }()
    
    private var languageSegmentControl: UISegmentedControl = {
        let segmentControll = settingSegmentControl()
        segmentControll.tag = LearnSettings.Settings.language.rawValue
        return segmentControll
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
        questionSegmentControl.selectedSegmentIndex = question.rawValue
        answerSegmentControl.selectedSegmentIndex = answer.rawValue
        languageSegmentControl.selectedSegmentIndex = language.rawValue
    }
    
    @objc func segmentControlDidChanged(sender: UISegmentedControl) {
        let setting: LearnSettings.Settings
        let selectedIndex: Int
        switch sender.tag {
        case LearnSettings.Settings.question.rawValue:
            setting = .question
            selectedIndex = questionSegmentControl.selectedSegmentIndex
        case LearnSettings.Settings.answer.rawValue:
            setting = .answer
            selectedIndex = answerSegmentControl.selectedSegmentIndex
        case LearnSettings.Settings.language.rawValue:
            setting = .language
            selectedIndex = languageSegmentControl.selectedSegmentIndex
        default:
            return
        }
        
        delegate?.segmentControlDidChanged(setting: setting, index: selectedIndex)
    }
    
    // MARK: - Private functoions
    
    private func configureSegments() {
        LearnSettings.Settings.allCases.forEach { setting in
            let titleLabel = settingTitleLabel(setting.name)
            let descriptionLabel = settingDescriptionLabel(setting.description)
            let segmentStackView = UIStackView(arrangedSubviews: [
                titleLabel,
                descriptionLabel
            ])
            segmentStackView.axis = .vertical
            segmentStackView.translatesAutoresizingMaskIntoConstraints = false
            segmentStackView.spacing = Grid.pt4
            
            switch setting {
            case .question:
                LearnSettings.Question.allCases.enumerated().forEach { index, question in
                    configureSegemntedControl(
                        segmentControl: questionSegmentControl,
                        index: index,
                        setting: question
                    )
                }
                addAction(for: questionSegmentControl)
                segmentStackView.addArrangedSubview(questionSegmentControl)
            case .answer:
                LearnSettings.Answer.allCases.enumerated().forEach { index, answer in
                    configureSegemntedControl(
                        segmentControl: answerSegmentControl,
                        index: index,
                        setting: answer
                    )
                }
                addAction(for: answerSegmentControl)
                segmentStackView.addArrangedSubview(answerSegmentControl)
            case .language:
                LearnSettings.Language.allCases.enumerated().forEach { index, language in
                    configureSegemntedControl(
                        segmentControl: languageSegmentControl,
                        index: index,
                        setting: language
                    )
                }
                addAction(for: languageSegmentControl)
                segmentStackView.addArrangedSubview(languageSegmentControl)
            }
            stackView.addArrangedSubview(segmentStackView)
        }
    }
    
    private func configureSegemntedControl(
        segmentControl: UISegmentedControl,
        index: Int,
        setting: Settingable
    ) {
        let title = setting.name
        let image = setting.image
        if let image = image {
            segmentControl.insertSegment(with: image, at: index, animated: true)
        } else {
            segmentControl.insertSegment(withTitle: title, at: index, animated: true)
        }
    }
    
    private func addAction(for segmentControl: UISegmentedControl) {
        segmentControl.addTarget(
            self,
            action: #selector(segmentControlDidChanged(sender:)),
            for: .valueChanged
        )
    }
    
    // MARK: - UI
    
    private func configureView() {
        
    }
    
    private func configureSubviews() {
        self.addSubview(container)
        configureSegments()
        container.addSubview(stackView)
    }
    
    private static  func settingSegmentControl() -> UISegmentedControl {
        let segmentControl = UISegmentedControl()
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.selectedSegmentIndex = .zero
        return segmentControl
    }
    
    private func settingTitleLabel(_ title: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .titleBold3
        label.text = title
        return label
    }
    
    private func settingDescriptionLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .subhead
        label.text = text
        return label
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
