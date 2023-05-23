//
//  LearnProgressView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 11.05.2023.
//

import UIKit

class LearnProgressView: UIView {
    
    // MARK: - Subviews
    
    private lazy var progressStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            progressCurrentLabel,
            progressView,
            progressTotalLabel
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = Grid.pt8
        return stackView
    }()
    
    private var progressView: FlexProgressView = {
        let progressView = FlexProgressView(progressViewStyle: .bar)
        progressView.backgroundColor = .fiveBackgroundColor
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    private var progressCurrentLabel: UILabel = {
        return LearnProgressView.label()
    }()
    
    private var progressTotalLabel: UILabel = {
        return LearnProgressView.label()
    }()
    
    // MARK: - Constraction
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(progressStackView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func setProgress(_ cardIndex: CardIndex) {
        progressView.setProgress(cardIndex.progress, animated: true)
        progressCurrentLabel.text = String(cardIndex.current)
        progressTotalLabel.text = String(cardIndex.count)
    }
    
    // MARK: - Private functions
    
    private static func label() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .captionBold1
        label.textColor = .secondaryLabel
        return label
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            progressStackView.topAnchor.constraint(equalTo: topAnchor),
            progressStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            progressCurrentLabel.widthAnchor.constraint(equalTo: progressTotalLabel.widthAnchor)
        ])
    }
}
