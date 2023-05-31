//
//  ResultStackView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 27.04.2023.
//

import UIKit

protocol ResultableView {
    var kind: ResultStackView.Result { get }
    var titleLabel: UILabel { get }
    var resultLabel: UILabel { get }
}

final class ResultStackView: UIStackView, ResultableView {
    
    enum Result {
        case learns, result, time
        
        var title: String {
            switch self {
            case .learns:
                return NSLocalizedString("Workouts", comment: "Title")
            case .result:
                return NSLocalizedString("Last result", comment: "Title")
            case .time:
                return NSLocalizedString("Last time", comment: "Title")
            }
        }
    }
    
    var kind: Result
    
    // MARK: - Subviews
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    let resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Constraction
    
    required init(kind: Result) {
        self.kind = kind
        super.init(frame: .zero)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    // MARK: - Private functions
    
    private func configure() {
        self.addArrangedSubview(titleLabel)
        self.addArrangedSubview(resultLabel)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .horizontal
        self.distribution = .fill
        self.alignment = .leading
        self.titleLabel.text = kind.title + ": "
    }
}
