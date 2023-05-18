//
//  ResultStackView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 27.04.2023.
//

import UIKit

protocol ResultableView {
    func setResult(studyCellModel: StudyCellModel, type: ResultStackView.Result)
    func clear()
}

final class ResultStackView: UIStackView {
    
    enum Result {
        case learns, result, time
    }
    
    // MARK: - Subviews
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .caption2
        return label
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .titleBold3
        return label
    }()
    
    // MARK: - Constraction
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        self.axis = .vertical
        self.distribution = .fill
    }
}

extension ResultStackView: ResultableView {
    
    // MARK: - Functions
    // swiftlint:disable line_length
    
    func setResult(studyCellModel: StudyCellModel, type: Result) {
        var result: String = ""
        switch type {
        case .learns:
            result = String(studyCellModel.learnCount)
            titleLabel.text = NSLocalizedString("Тренировок", comment: "Title")
        case .result:
            if let lastResult = studyCellModel.lastResult {
                result = "\(String(describing: lastResult)) / \(String(describing: studyCellModel.wordsCount))"
            }
            titleLabel.text = NSLocalizedString("Результат", comment: "Title")
        case .time:
            result = studyCellModel.time ?? ""
            titleLabel.text = NSLocalizedString("Время", comment: "Title")
        }
        resultLabel.text = result
    }
    // swiftlint:enable line_length
    
    func clear() {
        resultLabel.text = nil
    }
}
