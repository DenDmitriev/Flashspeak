//
//  HintView.swift
//  FlashSpeak
//
//  Created by Оксана Каменчук on 22.05.2023.
//
// swiftlint: disable line_length

import UIKit

protocol HintViewDelegate: AnyObject {
     func getIndex(_ index: Int)
 }

class HintView: UIView {
    
    weak var delegate: HintViewDelegate?
    
    var hints = [NSLocalizedString("To add a word use the enter key, a comma after the word, or the + button, which is located to the right of the input field.", comment: "Title"), NSLocalizedString("To delete or correct an already entered word, click on it and hold for a couple of seconds, the delete field and the edit field are activated. Drag the word to the desired field.", comment: "Title")]
    
    private var currentIndex = 0 {
        didSet {
            delegate?.getIndex(currentIndex)
            pageControl.currentPage = currentIndex
        }
    }
    
    // MARK: - Subviews
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .tertiarySystemBackground
        view.layer.cornerRadius = Grid.cr16
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            pageControl,
            paragraphOneLabel,
            furtherButton
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = Grid.pt8
        stackView.layoutMargins.bottom = safeAreaInsets.bottom
        stackView.isLayoutMarginsRelativeArrangement = true
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(viewSwiped(_:)))
        swipeLeft.direction = .left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(viewSwiped(_:)))
        swipeRight.direction = .right
        stackView.addGestureRecognizer(swipeLeft)
        stackView.addGestureRecognizer(swipeRight)

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
        control.currentPageIndicatorTintColor = .tint
        control.addTarget(
            self,
            action: #selector(pageControlDidChange(_:)),
            for: .valueChanged
        )
        return control
    }()
    
    var paragraphOneLabel: UILabel = {
        let label = PaddingLabel(withInsets: Grid.pt8, Grid.pt8, Grid.pt8, Grid.pt8)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .titleLight4
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let furtherButton: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .appFilled()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Further", comment: "Button"), for: .normal)
        button.tintColor = .tint
        return button
    }()
    
    // MARK: - Constraction
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        currentIndex = sender.currentPage
    }

    @objc func viewSwiped(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            currentIndex = (currentIndex + 1) % hints.count
        } else if sender.direction == .right {
            currentIndex = (currentIndex + hints.count - 1) % hints.count
        }
    }

    // MARK: - UI
    
    private func configureView() {
        
    }
    
    private func configureSubviews() {
        self.addSubview(container)
        container.addSubview(stackView)
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        let insetsContainer = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: insetsContainer.top),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: insetsContainer.left),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -insetsContainer.right),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -insetsContainer.bottom)

        ])
    }
    
}

// swiftlint: enable line_length
