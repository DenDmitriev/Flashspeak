//
//  ListWordsCell.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 13.04.2023.
//

import UIKit

class ListWordsCell: UITableViewCell {
    
    static let identifier = "ListWordsCell"
    private var style: GradientStyle = .grey
    
    //MARK: - Views
    
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .Theme.textWhite
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.numberOfLines = 2
//        label.backgroundColor = .darkGray
        return label
    }()
    
    lazy private var wordsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
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
    
    
    lazy private var separator = UIView()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureStyle()
    }
    
    //MARK: - Methods
    
    func configure(listWors: ListWords) {
        titleLabel.text = listWors.title
        wordsLabel.text = listWors.words.joined(separator: ", ")
        style = listWors.style
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - UI
    
    private func configureStyle() {
        let layer = CAGradientLayer.gradientLayer(for: style, in: stack.frame)
        layer.cornerRadius = 16
        stack.layer.insertSublayer(layer, at: 0)
    }
    
    override func prepareForReuse() {
        [titleLabel, wordsLabel].forEach { $0.text = nil }
    }
    
    private func configureUI() {
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(wordsLabel)
        contentView.addSubview(stack)
        separator.frame = CGRect(x: 0, y: 0, width: 8, height: 8)
        contentView.addSubview(separator)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            stack.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 0),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
    }

}
