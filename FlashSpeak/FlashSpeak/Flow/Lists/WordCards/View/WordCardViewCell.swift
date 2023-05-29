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
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
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
    
    private var topConstraintStack: NSLayoutConstraint?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        topConstraintStack = stackView.topAnchor.constraint(equalTo: imageView.topAnchor)
        topConstraintStack?.isActive = true
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
        topConstraintStack?.isActive = true
//        stackView.layer.sublayers?.first?.removeFromSuperlayer()
    }
    
    // MARK: - Methods
    
    func configure(wordCardCellModel: WordCardCellModel, style: GradientStyle, menu: UIMenu) {
        wordLabel.text = wordCardCellModel.source
        translationLabel.text = wordCardCellModel.translation
        self.style = style
        if let image = wordCardCellModel.image {
            imageView.image = image.roundedImage(cornerRadius: Grid.cr16)
            topConstraintStack?.isActive = false
            configureStack()
        }
        self.toolTipButton.menu = menu
    }
    
    // MARK: - Privae functions
    
    // MARK: - UI
    
    private func configureUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(stackView)
        contentView.addSubview(toolTipButton)
        setupConstraints()
    }
    
    private func configureStyle() {
        let layer = CAGradientLayer.gradientLayer(for: style, in: contentView.frame)
        layer.cornerRadius = Grid.cr8
        contentView.layer.insertSublayer(layer, at: 0)
    }
    
    private func configureStack() {
        layoutIfNeeded()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = imageView.bounds
        gradientLayer.colors = [UIColor.clear.cgColor, CAGradientLayer.beginColor(for: style).cgColor]
        imageView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        imageView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            
            wordLabel.heightAnchor.constraint(equalTo: translationLabel.heightAnchor, multiplier: 1),
            
            toolTipButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Grid.pt8),
            toolTipButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Grid.pt8)
        ])
    }
    
}
