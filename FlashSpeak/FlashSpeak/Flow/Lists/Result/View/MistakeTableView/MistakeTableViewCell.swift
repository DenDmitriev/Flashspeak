//
//  MistakeTableViewCell.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 03.06.2023.
//

import UIKit

class MistakeTableViewCell: UITableViewCell {
    
    static let identifier = "MistakeTableViewCell"
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            sourceLabel,
            translationLabel,
            mistakeLabel
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = Grid.pt8
        stackView.distribution = .fillEqually
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(
            top: Grid.pt8,
            left: Grid.pt8,
            bottom: Grid.pt8,
            right: Grid.pt8
        )
        return stackView
    }()
    
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let translationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .systemGreen
        return label
    }()
    
    private let mistakeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .systemRed
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
        addConstraints()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(viewModel: WordCellModel) {
        sourceLabel.text = viewModel.source
        translationLabel.text = viewModel.translation
        if !viewModel.mistake.isEmpty {
            let attributedText = NSAttributedString(
                string: viewModel.mistake,
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            mistakeLabel.attributedText = attributedText
        }
    }
    
    private func configureSubviews() {
        contentView.addSubview(stackView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
}
