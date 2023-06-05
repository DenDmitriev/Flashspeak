//
//  LearnTimerView.swift
//  FlashSpeak
//
//  Created by Оксана Каменчук on 30.05.2023.
//

import UIKit
import Combine

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
    
    private let formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = [.default]
        return formatter
    }()
    
    private var timerLabel: UILabel = {
        return LearnTimerView.label()
    }()

    
    // MARK: - Constraction
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .fiveBackgroundColor
        timerLabel.text = formatter.string(from: .zero)
        addSubview(timerStackView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = timerStackView.frame.height / 2
        layer.masksToBounds = true
    }
    
    // MARK: - Functions
    
    func updateTimer(timeInterval: TimeInterval) {
        let text = formatter.string(from: timeInterval)
        timerLabel.text = text
    }

    // MARK: - Private functions
    
    private static func label() -> UILabel {
        let label = PaddingLabel(withInsets: Grid.pt8, Grid.pt8, Grid.pt8, Grid.pt8)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .title3
        label.textColor = .secondaryLabel
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
