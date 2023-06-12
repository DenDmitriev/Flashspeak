//
//  SegmentedControlCell.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 25.05.2023.
//

import UIKit


class SegmentedControlCell: UITableViewCell {
    typealias Item = LearnSettingProtocol
    
    static let identifier = "SegmentedControlCell"
    
    weak var delegate: SettingsCellDelegate?
    private var settings: (any LearnSettingProtocol)?
    
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
        selectionStyle = .none
        addTarget()
        configureUI()
        setupConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        settings = nil
    }
    
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
        self.settings = setting
        titleLabel.text = setting.title
        configureSegmentedControl(setting)
    }
    
    // MARK: - Private functions
    
    private func addTarget() {
        segmentControl.addTarget(self, action: #selector(valueChanged(sender:)), for: .valueChanged)
    }
    
    @objc func valueChanged(sender: UISegmentedControl) {
        settings?.changed(controlValue: sender.selectedSegmentIndex)
        guard let settings = settings else { return }
        settings.delegate?.changed(setting: settings)
        delegate?.valueChanged()
    }
    
    private func configureSegmentedControl(_ settings: any LearnSettingProtocol) {
        settings.all.enumerated().forEach { index, setting in
            segmentControl.insertSegment(withTitle: setting.title, at: index, animated: true)
        }
        if let contolValue: Int = settings.getControlValue() {
            segmentControl.selectedSegmentIndex = contolValue
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
