//
//  CardView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 15.05.2023.
//

import UIKit

class CardView: UIView {

    // MARK: - Properties
    
    var style: GradientStyle?
    var tabBarHeight: CGFloat?
    
    // MARK: - Private properties
    
    private var topAnchorWordStackView = NSLayoutConstraint()
    
    /// InitialI intersection betwen collectionView and wordStackView
    enum IntersectionAnchor {
        static let initial = Grid.pt32
    }
    
    // MARK: - Subviews
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var wordStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            sourceLabel,
            translationFiled
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutMargins = UIEdgeInsets(
            top: Grid.pt64,
            left: Grid.pt8,
            bottom: Grid.pt32,
            right: Grid.pt8
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.alignment = .fill
        stackView.spacing = Grid.pt8
        stackView.axis = .vertical
        stackView.layer.cornerRadius = Grid.cr8
        stackView.layer.masksToBounds = true
        return stackView
    }()
    
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .title1
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let translationFiled: UITextField = {
        let textFiled = UITextField()
        textFiled.borderStyle = .roundedRect
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        textFiled.placeholder = NSLocalizedString("Напишите перевод", comment: "Placeholder")
        textFiled.font = .title1
        textFiled.textAlignment = .center
        return textFiled
    }()
    
    // MARK: - Constraction

    override init(frame: CGRect) {
        super.init(frame: frame)
        addObserverKeyboard()
        configureGesture()
        configureSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Lifecycle
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupAppearance()
    }
    
    // MARK: - Functions
    
    func configureView(model: CardViewModel?) {
        sourceLabel.text = model?.source
        translationFiled.text = model?.translation
    }
    
    // MARK: - Private Functions
    
    private func addObserverKeyboard() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(adjustForKeyboard),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(adjustForKeyboard),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard
            let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = convert(keyboardScreenEndFrame, from: window)
        let tabBarInset = Grid.pt16
        let spaceHeight = frame.height - scrollView.frame.height
        let bottomInset = keyboardViewEndFrame.height - (tabBarHeight ?? .zero) - tabBarInset - spaceHeight
        
        if notification.name == UIResponder.keyboardWillHideNotification {
//            scrollView.contentInset.bottom = .zero
            topAnchorWordStackView.constant = -IntersectionAnchor.initial
        } else {
//            scrollView.contentInset.bottom = bottomInset
            topAnchorWordStackView.constant -= bottomInset
        }
        
        UIView.animate(withDuration: 0.3) {
            self.setNeedsUpdateConstraints()
            self.layoutIfNeeded()
        }
    }
    
    private func configureGesture() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard(sender:))
        )
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(sender: UIGestureRecognizer) {
        translationFiled.resignFirstResponder()
    }
    
    // MARK: - UI
    
    private func configureSubviews() {
        scrollView.addSubview(collectionView)
        scrollView.addSubview(wordStackView)
        addSubview(scrollView)
    }
    
    private func setupAppearance() {
        wordStackView.backgroundColor = UIColor.color(by: style ?? .grey)
    }
    
    private func setupConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        topAnchorWordStackView = wordStackView.topAnchor.constraint(
            equalTo: collectionView.bottomAnchor,
            constant: -IntersectionAnchor.initial
        )
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            
            collectionView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: Grid.factor50),
            collectionView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            
            topAnchorWordStackView,
            wordStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Grid.pt16),
            wordStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Grid.pt16),
            
            translationFiled.heightAnchor.constraint(equalToConstant: Grid.pt48)
        ])
    }
}
