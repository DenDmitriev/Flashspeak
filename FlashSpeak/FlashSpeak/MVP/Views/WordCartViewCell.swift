//
//  WordCartViewCell.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 15.04.2023.
//

import UIKit

class WordCartViewCell: UICollectionViewCell {
    
    static let identifier = "WordCartCell"
    private var style: GradientStyle = .grey
    
    //MARK: - SubViews
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var wordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .Theme.textWhite
        label.textAlignment = .center
        return label
    }()
    
    lazy var translationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .Theme.textWhite
        label.textAlignment = .center
        return label
    }()
    
    lazy var imageView: UIImageView =  {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureStyle()
    }
    
    //MARK: - Methods
    
    func configure(word: Word) {
        wordLabel.text = word.source
        translationLabel.text = word.translation
        style = .red//word.list.style
        if let nameImage = word.imageURL?.absoluteString {
            imageView.image = UIImage(named: nameImage)
        } else {
            //imageView.removeFromSuperview()
        }
    }
    
    //MARK: - UI
    
    private func configureUI() {
        stackView.addArrangedSubview(wordLabel)
        stackView.addArrangedSubview(translationLabel)
        stackView.addArrangedSubview(imageView)
        contentView.addSubview(stackView)
        setupConstraints()
    }
    
    private func configureStyle() {
        let layer = CAGradientLayer.gradientLayer(for: style, in: contentView.frame)
        layer.cornerRadius = 16
        contentView.layer.insertSublayer(layer, at: 0)
    }
    
    //MARK: - Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
}
