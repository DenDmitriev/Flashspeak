//
//  SegmentedControlCell.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 25.05.2023.
//

import UIKit

class SegmentedControlCell: UITableViewCell {
    
    static let identifier = "SegmentedControlCell"
    weak var delegate: SettingsCellDelegate?
    private var setting: LearnSettings.Settings?
    
    // MARK: - SubViews
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            segmentControl
        ])
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.layoutMargins = UIEdgeInsets(
            top: Grid.pt8,
            left: Grid.pt16,
            bottom: Grid.pt8,
            right: Grid.pt16
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl()
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentControl
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .secondarySystemBackground
        addTarget()
        configureUI()
        setupConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Functions
    
    func configure(question: LearnSettings.Question) {
        setting = .question
        configureSegmentedControl(.question)
        titleLabel.text = LearnSettings.Settings.question.name
        segmentControl.selectedSegmentIndex = question.rawValue
    }
    
    func configure(answer: LearnSettings.Answer) {
        setting = .answer
        configureSegmentedControl(.answer)
        titleLabel.text = LearnSettings.Settings.answer.name
        segmentControl.selectedSegmentIndex = answer.rawValue
    }
    
    func configure(language: LearnSettings.Language) {
        setting = .language
        configureSegmentedControl(.language)
        titleLabel.text = LearnSettings.Settings.language.name
        segmentControl.selectedSegmentIndex = language.rawValue
    }
    
    // MARK: - Private functions
    
    private func addTarget() {
        segmentControl.addTarget(self, action: #selector(valueChanged(sender:)), for: .valueChanged)
    }
    
    @objc func valueChanged(sender: UISegmentedControl) {
        delegate?.segmentedControlChanged(sender: sender, setting: setting)
    }
    
    private func configureSegmentedControl(_ control: LearnSettings.Settings) {
        switch control {
        case .question:
            LearnSettings.Question.allCases.enumerated().forEach { index, language in
                segmentControl.insertSegment(withTitle: language.name, at: index, animated: true)
            }
        case .answer:
            LearnSettings.Answer.allCases.enumerated().forEach { index, language in
                segmentControl.insertSegment(withTitle: language.name, at: index, animated: true)
            }
        case .language:
            LearnSettings.Language.allCases.enumerated().forEach { index, language in
                segmentControl.insertSegment(withTitle: language.name, at: index, animated: true)
            }
        }
    }
    
    // MARK: - UI
    
    private func configureUI() {
        contentView.addSubview(stackView)
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

}
