//
//  StudyCell.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 27.04.2023.
//

import UIKit

class StudyCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "StudyCell"
    private var style: GradientStyle = .grey
    
    // MARK: - Subviews
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textWhite
        label.font = UIFont.title2
        label.numberOfLines = 1
//        label.backgroundColor = .gray.withAlphaComponent(Grid.factor25)
        return label
    }()
    
    private var learnsView: UIStackView & ResultableView = {
        let view = ResultStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var resultView: UIStackView & ResultableView = {
        let view = ResultStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var timeView: UIStackView & ResultableView = {
        let view = ResultStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var resultsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            learnsView,
            resultView,
            timeView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = Grid.pt8
        stackView.distribution = .fillEqually
//        stackView.backgroundColor = .gray.withAlphaComponent(Grid.factor25)
        return stackView
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            resultsStackView
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = Grid.pt4
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.layer.cornerRadius = Grid.cr16
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: Grid.pt8,
            leading: Grid.pt16,
            bottom: Grid.pt8,
            trailing: Grid.pt16
        )
        return stack
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureStyle()
    }
    
    
    // MARK: - Methods
    
    func configure(studyCellModel: StudyCellModel) {
        titleLabel.text = studyCellModel.title
        
        resultView.setResult(studyCellModel: studyCellModel, type: .result)
        learnsView.setResult(studyCellModel: studyCellModel, type: .learns)
        timeView.setResult(studyCellModel: studyCellModel, type: .time)
        
        style = studyCellModel.style
        layoutSubviews()
    }
    
    // MARK: - UI
    
    private func configureStyle() {
        let layer = CAGradientLayer.gradientLayer(for: style, in: contentView.frame)
        layer.cornerRadius = Grid.cr16
        contentView.layer.insertSublayer(layer, at: 0)
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        learnsView.clear()
        resultView.clear()
        timeView.clear()
    }
    
    private func configureUI() {
        contentView.addSubview(stack)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
    }
}
