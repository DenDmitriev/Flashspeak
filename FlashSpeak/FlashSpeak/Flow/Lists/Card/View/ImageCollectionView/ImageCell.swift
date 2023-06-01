//
//  ImageCell.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 15.05.2023.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier: String = "ImageCell"
    
    // MARK: - Subviews
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = Grid.cr8
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.tint.cgColor
        return imageView
    }()
    
    // MARK: - Constraction
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override var isSelected: Bool {
        willSet {
            super.isSelected = newValue
            if newValue {
                imageView.layer.borderWidth = Grid.pt4
            } else {
                imageView.layer.borderWidth = .zero
            }
        }
    }
    
    // MARK: - Functions
    
    func configure(image: UIImage) {
        imageView.image = image
    }
    
    func imageSize() -> CGSize? {
        return imageView.image?.size
    }
    
    // MARK: - UI
    
    private func configureUI() {
        contentView.addSubview(imageView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
}
