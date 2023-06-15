//
//  AnswerButtonCell.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 06.05.2023.
//

import UIKit

class AnswerButtonCell: UICollectionViewCell {
    
    // MARK: - Propetes
    
    static let identifier = "AnswerButtonCell"
    
    // MARK: - Subviews
    
    let button: UIButton = {
        let button = UIButton(configuration: .appFilled())
        button.translatesAutoresizingMaskIntoConstraints = false
        let title = NSLocalizedString("Check", comment: "Button")
        button.setTitle(title, for: .normal)
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureSubviews()
        addConstraints()
    }
    
    // MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func configureView() {
        
    }
    
    private func configureSubviews() {
        contentView.addSubview(button)
    }
    
    // MARK: - Methods
    
    // MARK: - Constraints
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
