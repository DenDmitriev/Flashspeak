//
//  LearnTimerView.swift
//  FlashSpeak
//
//  Created by Оксана Каменчук on 30.05.2023.
//

import UIKit

class LearnTimerView: UIView {
    
    // MARK: - Subviews
    
    private lazy var timerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            timerLabel
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = Grid.pt8
        return stackView
    }()
    
    var timerLabel: UILabel = {
        return LearnTimerView.label()
    }()

    
    // MARK: - Constraction
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(timerStackView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    

    // MARK: - Private functions
    
    private static func label() -> UILabel {
        let label = PaddingLabel(withInsets: Grid.pt8, Grid.pt8, Grid.pt8, Grid.pt8)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .title3
        label.textColor = .secondaryLabel
        label.backgroundColor = .systemBackground
        label.textAlignment = .right
        return label
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            timerStackView.topAnchor.constraint(equalTo: topAnchor),
            timerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            timerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            timerStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
    }
}
