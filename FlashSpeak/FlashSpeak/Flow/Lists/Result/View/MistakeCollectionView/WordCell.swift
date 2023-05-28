//
//  WordCell.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 27.05.2023.
//

import UIKit

class WordCell: UICollectionViewCell {
    static let identifier = "WordCell"
    
    // MARK: - Subviews
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            sourceLabel,
            translationLabel
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Grid.pt4
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .secondarySystemBackground
        stackView.layer.cornerRadius = Grid.pt12
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: Grid.pt8, left: Grid.pt16, bottom: Grid.pt8, right: Grid.pt16)
        return stackView
    }()
    
    let sourceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .titleBold3
        label.textAlignment = .left
//        label.adjustsFontSizeToFitWidth = true
        label.textColor = .systemRed
        return label
    }()
    
    let translationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .titleBold3
        label.textAlignment = .left
//        label.adjustsFontSizeToFitWidth = true
        label.textColor = .systemGreen
        return label
    }()
    
    // MARK: - Constraction
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        sourceLabel.text = nil
        translationLabel.text = nil
    }
    
    // MARK: Functions
    
    func configure(viewModel: WordCellModel) {
        sourceLabel.text = viewModel.source
        translationLabel.text = viewModel.translation
    }
    
    // MARK: - UI
    
    private func configureView() {
        
    }
    
    private func configureSubviews() {
        contentView.addSubview(stackView)
    }
    
    // MARK: - Constraints
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
