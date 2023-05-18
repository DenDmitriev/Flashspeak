//
//  WordCartViewCell.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 15.04.2023.
//

import UIKit

class WordCardViewCell: UICollectionViewCell {
    
    static let identifier = "WordCartCell"
    
    private var style: GradientStyle = .grey
    
    // MARK: - SubViews
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            wordLabel,
            translationLabel
        ])
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.layoutMargins = UIEdgeInsets(
            top: Grid.pt8,
            left: Grid.pt4,
            bottom: Grid.pt8,
            right: Grid.pt4
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    lazy var wordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.titleLight4
        label.textColor = .textWhite
        label.textAlignment = .center
        return label
    }()
    
    lazy var translationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.titleBold3
        label.textColor = .textWhite
        label.textAlignment = .center
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = Grid.cr8
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    
    // MARK: - Init
    
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
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Methods
    
    func configure(wordCardCellModel: WordCardCellModel, style: GradientStyle) {
        wordLabel.text = wordCardCellModel.source
        translationLabel.text = wordCardCellModel.translation
        self.style = style
        if let image = wordCardCellModel.image {
            imageView.image = image.roundedImage(cornerRadius: Grid.cr16)
//            if !stackView.arrangedSubviews.contains(imageView) {
//                stackView.insertArrangedSubview(imageView, at: .zero)
//            }
        } else {
//            imageView.removeFromSuperview()
        }
    }
    
    // MARK: - Privae functions
    
    // MARK: - UI
    
    private func configureUI() {
        contentView.addSubview(stackView)
        setupConstraints()
    }
    
    private func configureStyle() {
        let layer = CAGradientLayer.gradientLayer(for: style, in: contentView.frame)
        layer.cornerRadius = Grid.cr8
        contentView.layer.insertSublayer(layer, at: 0)
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            wordLabel.heightAnchor.constraint(equalTo: translationLabel.heightAnchor, multiplier: 1)
        ])
    }
    
}
