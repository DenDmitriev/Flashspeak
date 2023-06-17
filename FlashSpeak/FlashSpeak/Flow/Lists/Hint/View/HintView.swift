//
//  HintView.swift
//  FlashSpeak
//
//  Created by Оксана Каменчук on 22.05.2023.
//
// swiftlint: disable line_length

import UIKit

 protocol HintViewDelegate: AnyObject {
     func pageDidChange(_ index: Int)
 }

class HintView: UIView {
    
    weak var delegate: HintViewDelegate?
    var hints: [String]
    
    // MARK: - Subviews
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .tertiarySystemBackground
        view.layer.cornerRadius = Grid.cr16
        return view
    }()
    
    private let pagesScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    private let pagesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            pagesScrollView,
            pageControl
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = Grid.pt8
        return stackView
    }()
    
    private var titleLabel: UILabel = {
        let label = PaddingLabel(withInsets: Grid.pt8, Grid.pt8, Grid.pt8, Grid.pt8)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .titleBold1
        label.text = NSLocalizedString("Hint", comment: "Title")
        return label
    }()
    
    lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = hints.count
        control.translatesAutoresizingMaskIntoConstraints = false
        control.isUserInteractionEnabled = true
        control.pageIndicatorTintColor = UIColor.gray
        control.currentPageIndicatorTintColor = .tintColor
        control.addTarget(
            self,
            action: #selector(pageControlDidChange(_:)),
            for: .valueChanged
        )
        return control
    }()
    
    let furtherButton: UIButton = {
        let button = UIButton(configuration: .appFilled())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Further", comment: "Button"), for: .normal)
        return button
    }()
    
    // MARK: - Constraction
    
    init(hints: [String], delegate: HintViewDelegate) {
        self.hints = hints
        self.delegate = delegate
        super.init(frame: .zero)
        configureView()
        configureSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Functins
    
    @objc func pageControlDidChange(_ sender: UIPageControl) {
        let rect = pagesStackView.arrangedSubviews[sender.currentPage].frame
        pagesScrollView.scrollRectToVisible(rect, animated: true)
        delegate?.pageDidChange(sender.currentPage)
    }
    
    func scrollToNextPage() {
        if pageControl.currentPage < (pageControl.numberOfPages - 1) {
            pageControl.currentPage += 1
            pageControlDidChange(pageControl)
        }
    }

    // MARK: - UI
    
    private func configureView() {
        pagesScrollView.delegate = self
        hints.enumerated().forEach { index, text in
            let label = UILabel()
            label.numberOfLines = .zero
            label.text = text
            label.font = .titleLight4
            label.sizeToFit()
            label.frame = .init(
                x: stackView.frame.width * CGFloat(index),
                y: pagesStackView.frame.minY,
                width: stackView.frame.width,
                height: label.frame.height
            )
            pagesStackView.addArrangedSubview(label)
        }
        pagesScrollView.addSubview(pagesStackView)
    }
    
    private func configureSubviews() {
        self.addSubview(container)
        self.addSubview(furtherButton)
        container.addSubview(stackView)
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: Grid.pt16),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Grid.pt16),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Grid.pt16),
            stackView.bottomAnchor.constraint(equalTo: furtherButton.topAnchor, constant: -Grid.pt16),

            furtherButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Grid.pt16),
            furtherButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Grid.pt16),
            furtherButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            furtherButton.heightAnchor.constraint(equalToConstant: Grid.pt44),
            
            pagesScrollView.heightAnchor.constraint(equalTo: pagesStackView.heightAnchor),
            
            pagesStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CGFloat(hints.count)),
            pagesStackView.topAnchor.constraint(equalTo: pagesScrollView.topAnchor),
            pagesStackView.leadingAnchor.constraint(equalTo: pagesScrollView.leadingAnchor),
            pagesStackView.trailingAnchor.constraint(equalTo: pagesScrollView.trailingAnchor),
            pagesStackView.bottomAnchor.constraint(equalTo: pagesScrollView.bottomAnchor)
        ])
    }
    
}

extension HintView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / stackView.frame.width)
        pageControl.currentPage = Int(pageIndex)
        delegate?.pageDidChange(Int(pageIndex))
    }
}

// swiftlint: enable line_length
