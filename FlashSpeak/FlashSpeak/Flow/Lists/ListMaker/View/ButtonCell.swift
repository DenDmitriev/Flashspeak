//
//  ButtonCell.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 17.05.2023.
//

import UIKit

class ButtonCell: UICollectionViewCell {
    // MARK: - Propetes
    
    static let identifier = "ButtonCell"
    
    // MARK: - Subviews
    
    let button: UIButton = {
        var configuration = UIButton.Configuration.appGray()
        configuration.imagePadding = Grid.pt8
        let button = UIButton(configuration: configuration)
        button.configuration?.background.backgroundColor = .systemRed.withAlphaComponent(Grid.factor35)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.tintColor = .systemRed
        let title = NSLocalizedString("Delete word", comment: "title")
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
    
    // MARK: - Functions
    
    func configure(image: UIImage?) {
        button.setImage(image, for: .normal)
    }
    
    func highlight(_ isActive: Bool) {
//        let color: UIColor = isActive ? .systemRed.withAlphaComponent(Grid.factor35) : .fiveBackgroundColor
//        button.configuration?.background.backgroundColor = color
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
