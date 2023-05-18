//
//  ActivityIndicatorView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 13.05.2023.
//

import UIKit

protocol ActivityIndicatorViewType: AnyObject {
    func start()
    func stop()
    func setTitle(_ title: String)
}

class ActivityIndicatorView: UIView {
    
    // MARK: - Subviews
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            activityIndicator,
            titleLabel
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = Grid.pt4
        stackView.alignment = .center
        stackView.layoutMargins = UIEdgeInsets(
            top: Grid.pt16,
            left: Grid.pt8,
            bottom: Grid.pt16,
            right: Grid.pt8
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = false
        return indicator
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        label.textAlignment = .center
        label.textColor = .tertiaryLabel
        return label
    }()
    
    // MARK: - Constraction
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureSubviews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    // MARK: - Private functions
    
    private func configureView() {
        backgroundColor = .fiveBackgroundColor
        layer.cornerRadius = Grid.cr8
        layer.masksToBounds = true
    }
    
    private func configureSubviews() {
        addSubview(stackView)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension ActivityIndicatorView: ActivityIndicatorViewType {
    
    // MARK: - Functions
    
    func start() {
        activityIndicator.startAnimating()
    }
    
    func stop() {
        activityIndicator.stopAnimating()
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
