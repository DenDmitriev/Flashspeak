//
//  LearnResultView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 21.05.2023.
//

import UIKit

class LearnResultView: UIView {
    
    // MARK: - Result Subviews
    
    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            learnsView,
            resultView,
            timeView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = Grid.pt8
        stackView.axis = .vertical
        return stackView
    }()
    
    private var learnsView: UIStackView & ResultableView = {
        let view = ResultStackView(kind: .learns)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var resultView: UIStackView & ResultableView = {
        let view = ResultStackView(kind: .result)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var timeView: UIStackView & ResultableView = {
        let view = ResultStackView(kind: .time)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Constraction
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        setContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LIfecycle

    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    // MARK: - Functions
    
    func setResult(learnings: [Learn], wordsCount: Int) {
        let lastResult = learnings.last?.result ?? .zero
        let lastTime = learnings.last?.duration() ?? "0"
        let learnCount = learnings.count
        
        let result = "\(String(describing: lastResult)) / \(String(describing: wordsCount))"
        resultView.resultLabel.text = result
        
        let learns = String(learnCount)
        learnsView.resultLabel.text = learns
        
        timeView.resultLabel.text = lastTime
    }
    
    // MARK: - Private Functions
    
    private func configureSubviews() {
        addSubview(contentStackView)
    }
    
    private func setContraints() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
