//
//  SwitchValueCell.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 10.06.2023.
//

import UIKit

class SwitchValueCell: UITableViewCell {
    typealias Item = CaseIterable & LearnSettingProtocol
    
    static let identifier = "SwitchValueCell"
    
    weak var delegate: SettingsCellDelegate?
    private var setting: (any LearnSettingProtocol)?
    
    // MARK: - SubViews
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            textFiled,
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
    
    var textFiled: UITextField = {
        let textFiled = UITextField()
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        textFiled.borderStyle = .roundedRect
        textFiled.placeholder = "Seconds"
        textFiled.isEnabled = false
        textFiled.keyboardType = .numberPad
        textFiled.textAlignment = .right
        let label = UILabel()
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second]
        formatter.unitsStyle = .brief
        var text = formatter.string(from: .zero)
        text?.removeFirst()
        label.text = text?.appending("  ")
        textFiled.rightView = label
        textFiled.rightViewMode = .always
        textFiled.backgroundColor = .systemGroupedBackground
        return textFiled
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
//        imageView?.image = setting.image
        titleLabel.text = setting.title
        if let isOn: Bool = setting.getControlValue() {
            switcher.setOn(isOn, animated: true)
            textFiled.isEnabled = isOn
        }
        if let value = setting.value {
            textFiled.text = String(value)
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
        textFiled.isEnabled = sender.isOn
        setting?.changed(controlValue: sender.isOn)
        delegate?.valueChanged()
    }
    
    // MARK: - UI
    
    private func configureUI() {
        textFiled.delegate = self
        contentView.addSubview(stackView)
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textFiled.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1 / 4)
        ])
    }

}

// swiftlint: disable line_length

extension SwitchValueCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard
            let value = textField.text,
            var setting = setting
        else { return }
        setting.value = Int(value)
        setting.changed(controlValue: switcher.isOn)
    }
}

// swiftlint: enable line_length
