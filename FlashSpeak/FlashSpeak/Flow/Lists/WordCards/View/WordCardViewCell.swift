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
            labelStackView
        ])
        stackView.spacing = .zero
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutMargins = UIEdgeInsets(
            top: Grid.pt2,
            left: Grid.pt2,
            bottom: Grid.pt2,
            right: Grid.pt2
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.backgroundColor = .tintColor
        stackView.layer.cornerRadius = Grid.cr12
        stackView.layer.masksToBounds = true
        return stackView
    }()
    
    lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            wordLabel,
            translationLabel
        ])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = Grid.pt8
        stackView.layoutMargins = UIEdgeInsets(
            top: Grid.pt8,
            left: Grid.pt8,
            bottom: Grid.pt8,
            right: Grid.pt8
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var wordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.titleBold3
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var translationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.titleBold3
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = Grid.cr12
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        configureStyle()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    // MARK: - Methods
    
    func configure(
        wordCardCellModel: WordCardCellModel,
        style: GradientStyle,
        menu: UIMenu,
        imageFlag: Bool
    ) {
        wordLabel.text = wordCardCellModel.source
        translationLabel.text = wordCardCellModel.translation
        self.style = style
        imageView.isHidden = !imageFlag
        if imageFlag {
            if let image = wordCardCellModel.image {
                imageView.image = image
                loader.isHidden = true
                loader.stopAnimating()
            } else {
                loader.isHidden = false
                loader.startAnimating()
                startTimer()
            }
        }
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
//        contentView.addSubview(imageView)
        contentView.addSubview(stackView)
        contentView.addSubview(toolTipButton)
        contentView.addSubview(loader)
        setupConstraints()
    }
    
    private func configureStyle() {
        stackView.backgroundColor = style.color
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
//            wordLabel.heightAnchor.constraint(equalToConstant: Grid.pt32),
//            translationLabel.heightAnchor.constraint(equalTo: wordLabel.heightAnchor),
            
            toolTipButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Grid.pt8),
            toolTipButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Grid.pt8)
        ])
        layoutIfNeeded()
        loader.center = CGPoint(x: imageView.center.x, y: imageView.center.y - Grid.pt16)
    }
    
}
