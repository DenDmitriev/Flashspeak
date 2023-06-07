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
        label.font = UIFont.titleBold3
        label.textColor = .textWhite
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var translationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.titleBold3
        label.textColor = .textWhite
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = Grid.cr8
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .systemGray4
        imageView.tintColor = .systemGray
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
    
    private let loader: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        return indicator
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    // MARK: - Methods
    
    func configure(wordCardCellModel: WordCardCellModel, style: GradientStyle, menu: UIMenu) {
        wordLabel.text = wordCardCellModel.source
        translationLabel.text = wordCardCellModel.translation
        self.style = style
        if let image = wordCardCellModel.image {
            imageView.image = image
            loader.isHidden = true
            loader.stopAnimating()
        } else {
            loader.isHidden = false
            loader.startAnimating()
            startTimer()
        }
        configureStack()
        self.toolTipButton.menu = menu
    }
    
    // MARK: - Privae functions
    
    private func startTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            if self?.imageView.image == nil {
                self?.loader.isHidden = true
                self?.loader.stopAnimating()
                self?.imageView.image = UIImage(named: "placeholder")
            }
        }
    }
    
    // MARK: - UI
    
    private func configureUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(stackView)
        contentView.addSubview(toolTipButton)
        contentView.addSubview(loader)
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
        layoutIfNeeded()
        loader.center = CGPoint(x: contentView.center.x, y: contentView.center.y - Grid.pt16)
    }
    
}
