//
//  PrepareLearnView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 25.05.2023.
//

import UIKit
import SwiftUI

class PrepareLearnView: UIView {
    
    // MARK: - Properties
    
    // MARK: - Private properties
    
    // MARK: - Subviews
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            resultStackView,
            listStackView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = Grid.pt16
        stackView.axis = .vertical
        stackView.layoutMargins = .init(
            top: Grid.pt16,
            left: Grid.pt16,
            bottom: (Grid.pt16 + safeAreaInsets.bottom),
            right: Grid.pt16
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    // MARK: Result View
    
    lazy var resultStackView: UIStackView = {
        let title = NSLocalizedString("Result", comment: "title")
        return groupStackView(title: title, arrangedSubviews: [
            chartStackView,
            lookStatisticButton
        ])
    }()
    
    var chartStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: List Subviews
    
    private lazy var listStackView: UIStackView = {
        let title = NSLocalizedString("List", comment: "title")
        return groupStackView(title: title, arrangedSubviews: [
            listLabel,
//            paragraphButtom,
            listButtonsStackView
        ])
    }()
    
    var listLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        return label
    }()
    
//    var paragraphButtom: UIButton = {
//        var configure: UIButton.Configuration = .plain()
//        configure.buttonSize = .small
//        let button = UIButton(configuration: configure)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        let more = NSLocalizedString("Read more", comment: "button")
//        let less = NSLocalizedString("Read less", comment: "button")
//        button.setTitle(less, for: .highlighted)
//        button.setTitle(more, for: .normal)
//        return button
//    }()
    
    private lazy var listButtonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            editWordsButton,
            editCardsButton
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = Grid.pt8
        stackView.axis = .vertical
        return stackView
    }()
    
    var editCardsButton: UIButton = {
        let title = NSLocalizedString("Edit cards", comment: "button")
        let button = PrepareLearnView.button(title: title)
        button.configuration = .appFilled()
        return button
    }()
    
    var editWordsButton: UIButton = {
        let title = NSLocalizedString("Edit list", comment: "button")
        let button = PrepareLearnView.button(title: title)
        button.configuration = .appFilled()
        return button
    }()
    
    var lookStatisticButton: UIButton = {
        let title = NSLocalizedString("Results", comment: "button")
        let button = PrepareLearnView.button(title: title)
        button.configuration = .appFilled()
        return button
    }()
    
    // MARK: Learn Subviews
    
    private lazy var learnButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            settingsButton,
            learnButton
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = Grid.pt8
        stackView.axis = .horizontal
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(
            top: Grid.pt16,
            left: Grid.pt16,
            bottom: Grid.pt16,
            right: Grid.pt16
        )
        return stackView
    }()
    
    var settingsButton: UIButton = {
        let title = NSLocalizedString("Mode setting", comment: "button")
        let image = UIImage(systemName: "gearshape.fill")
        let button = PrepareLearnView.button(title: nil)
        button.configuration = .appFilled()
        button.setImage(image, for: .normal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return button
    }()
    
    var learnButton: UIButton = {
        let title = NSLocalizedString("Start learning", comment: "button")
        let button = PrepareLearnView.button(title: title)
        return button
    }()
    
    private let learnLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Constraction
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .secondarySystemBackground
        configureSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Functions
    
    func setList(wordsCount: Int, words: [String]) {
        listLabel.text = words.joined(separator: ", ")
    }
    
    func setLearnLabel(text: String) {
        learnLabel.text = text
    }
    
    func setChartView(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        chartStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        chartStackView.addArrangedSubview(view)
    }
    
    // MARK: - Private Functions
    
    private func groupStackView(title: String, arrangedSubviews: [UIView]) -> UIStackView {
        let label = UILabel()
        label.text = title
        label.font = .titleBold3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.insertArrangedSubview(label, at: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = Grid.pt16
        stackView.axis = .vertical
        stackView.layoutMargins = .init(top: Grid.pt16, left: Grid.pt16, bottom: Grid.pt16, right: Grid.pt16)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layer.cornerRadius = Grid.cr12
        stackView.layer.masksToBounds = true
        stackView.backgroundColor = .systemBackground
        return stackView
    }
    
    private static func button(title: String?) -> UIButton {
        var configure = UIButton.Configuration.appFilled()
        let button = UIButton(configuration: configure)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.titleLabel?.minimumScaleFactor = 0.5
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }
    
    // MARK: - UI
    
    private func configureSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        addSubview(learnButtonStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: learnButtonStackView.topAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor),
            
            learnButtonStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            learnButtonStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            learnButtonStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            learnButton.heightAnchor.constraint(equalToConstant: Grid.pt48),
            lookStatisticButton.heightAnchor.constraint(equalToConstant: Grid.pt48),
            editCardsButton.heightAnchor.constraint(equalToConstant: Grid.pt48),
            editWordsButton.heightAnchor.constraint(equalToConstant: Grid.pt48)
        ])
    }
}
