//
//  AddImageCell.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 01.06.2023.
//

import UIKit

class AddImageCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier: String = "AddImageCell"
    
    // MARK: - Subviews
    
    let button: UIButton = {
        var configure: UIButton.Configuration = .borderless()
        configure.image = UIImage(systemName: "plus")
        configure.baseForegroundColor = .tintColor
        let button = UIButton(configuration: configure)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Constraction
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
        backgroundColor = .fiveBackgroundColor
        layer.cornerRadius = Grid.cr8
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func configureUI() {
        contentView.addSubview(button)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
