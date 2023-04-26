//
//  TokenCell.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 22.04.2023.
//

import UIKit

class TokenCell: UICollectionViewCell {
    
    static let identifier = "TokenCell"
    
    // MARK: - Subviews
    
    let tokenLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .subhead
        label.textColor = .textWhite
        label.textAlignment = .center
        label.backgroundColor = .tint
        label.numberOfLines = 1
        label.layer.cornerRadius = Grid.cr4
        label.layer.masksToBounds = true
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureView() {
        layer.cornerRadius = Grid.cr4
        layer.masksToBounds = true
    }
    
    // MARK: - UI
    
    private func configureSubviews() {
        contentView.addSubview(tokenLabel)
        // contentView.addSubview(deleteButton)
    }
    
    // MARK: - Methods
    
    func configure(text: String) {
        tokenLabel.text = text
    }
    
    // MARK: - Constraints
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            tokenLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            tokenLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tokenLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tokenLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
