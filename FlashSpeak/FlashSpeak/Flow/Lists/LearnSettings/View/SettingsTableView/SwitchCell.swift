//
//  SwitchCell.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 25.05.2023.
//

import UIKit

class SwitchCell: UITableViewCell {
    typealias Item = CaseIterable & LearnSettingProtocol
    
    static let identifier = "SwitchCell"
    
    weak var delegate: SettingsCellDelegate?
    private var setting: (any LearnSettingProtocol)?
    
    // MARK: - SubViews
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            switcher
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
    
    var switcher: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        toggle.isOn = false
        return toggle
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .secondarySystemGroupedBackground
        selectionStyle = .none
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
    
    func configure(setting: any LearnSettingProtocol) {
        self.setting = setting
        titleLabel.text = setting.title
        if let isOn: Bool = setting.getControlValue() {
            switcher.setOn(isOn, animated: true)
        }
        if setting.isHidden {
            switcher.isEnabled = false
        }
    }
    
    // MARK: - Private functions
    
    private func addTarget() {
        switcher.addTarget(self, action: #selector(valueChanged(sender:)), for: .valueChanged)
    }
    
    @objc func valueChanged(sender: UISwitch) {
        setting?.changed(controlValue: sender.isOn)
        delegate?.valueChanged()
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
