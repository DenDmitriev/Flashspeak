//
//  ListWordsCell.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 13.04.2023.
//

import UIKit

class ListWordsCell: UICollectionViewCell {
    
    static let identifier = "ListWordsCell"
    private var style: GradientStyle = .grey
    
    //MARK: - Views
    
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .Theme.textWhite
        label.font = UIFont.Theme.title2
        label.numberOfLines = 2
//        label.backgroundColor = .darkGray
        return label
    }()
    
    lazy private var wordsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.Theme.caption1
        label.textColor = .Theme.textWhite
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .natural
        label.lineBreakStrategy = .standard
        label.lineBreakMode = .byTruncatingTail
//        label.backgroundColor = .darkGray
        return label
    }()
    
    lazy private var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 4
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        stack.layer.cornerRadius = 16
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        return stack
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureStyle()
    }
    
    //MARK: - Methods
    
    func configure(listWors: List) {
        titleLabel.text = listWors.title
        wordsLabel.text = listWors.words.map({ $0.source }).joined(separator: ", ")
        style = listWors.style
    }
    
    //MARK: - UI
    
    private func configureStyle() {
        let layer = CAGradientLayer.gradientLayer(for: style, in: contentView.frame)
        layer.cornerRadius = 16
        contentView.layer.insertSublayer(layer, at: 0)
    }
    
    override func prepareForReuse() {
        [titleLabel, wordsLabel].forEach { $0.text = nil }
    }
    
    private func configureUI() {
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(wordsLabel)
        contentView.addSubview(stack)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
    }

}
