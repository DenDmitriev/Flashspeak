//
//  LanguageCell.swift
//  CoreDataTest
//
//  Created by Denis Dmitriev on 17.04.2023.
//

import UIKit

class LanguageCell: UITableViewCell {
    
    static let identifier = "LanguageCell"
    
    // MARK: - Subviews
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.titleBold3
        label.textColor = .label
        return label
    }()
    
    private var flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = Grid.cr4
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            flagImageView,
            titleLabel
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.layer.cornerRadius = Grid.cr8
        stackView.layoutMargins = UIEdgeInsets(
            top: Grid.pt8,
            left: Grid.pt8,
            bottom: Grid.pt8,
            right: Grid.pt8
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(stackView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Methods
    
    func configure(language: Language) {
        self.titleLabel.text = language.description
        self.flagImageView.image = UIImage(named: language.code)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        switch selected {
        case true:
            titleLabel.textColor = .tintColor
            stackView.backgroundColor = .systemGray5
        case false:
            titleLabel.textColor = .label
            stackView.backgroundColor = .clear
        }
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
            flagImageView.widthAnchor.constraint(equalTo: flagImageView.heightAnchor, multiplier: 4 / 3)
        ])
    }

}
