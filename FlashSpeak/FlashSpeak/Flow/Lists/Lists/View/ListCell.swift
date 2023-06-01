//
//  ListWordsCell.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 13.04.2023.
//

import UIKit

class ListCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "ListWordsCell"
    private var style: GradientStyle = .grey
    
    // MARK: - Views
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            wordsLabel
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 4
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fill
        stack.layer.cornerRadius = Grid.cr16
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = .init(top: Grid.pt16, leading: Grid.pt16, bottom: Grid.pt16, trailing: Grid.pt16)
        return stack
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textWhite
        label.font = UIFont.titleBold2
        label.numberOfLines = 2
//        label.backgroundColor = .darkGray
        return label
    }()
    
    private var wordsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.title3
        label.textColor = .textWhite
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.textAlignment = .natural
        label.lineBreakStrategy = .standard
        label.lineBreakMode = .byTruncatingTail
        //        label.backgroundColor = .darkGray
        return label
    }()
    
    let toolTipButton: UIButton = {
        var configure: UIButton.Configuration = .plain()
        configure.cornerStyle = .capsule
        configure.baseForegroundColor = .white
        configure.image = UIImage(systemName: "ellipsis.circle.fill")
        let button = UIButton(configuration: configure)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureStyle()
    }
    
    // MARK: - Methods
    
    func configure(listCellModel: ListCellModel, menu: UIMenu) {
        titleLabel.text = listCellModel.title
        wordsLabel.text = listCellModel.words.joined(separator: ", ")
        style = listCellModel.style
        toolTipButton.menu = menu
        layoutSubviews()
    }
    
    // MARK: - UI
    
    private func configureStyle() {
        let layer = CAGradientLayer.gradientLayer(for: style, in: contentView.frame)
        layer.cornerRadius = Grid.cr16
        contentView.layer.insertSublayer(layer, at: 0)
    }
    
    private func configureUI() {
        contentView.addSubview(stackView)
        contentView.addSubview(toolTipButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            toolTipButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Grid.pt8),
            toolTipButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Grid.pt8)
        ])
    }
    
}
