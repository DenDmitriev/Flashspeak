//
//  CardView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 15.05.2023.
//
// swiftlint: disable line_length

import UIKit

protocol CardViewDelegate: AnyObject {
    func addImage()
}

class CardView: UIView {

    // MARK: - Properties
    
    var style: GradientStyle?
    weak var delegate: CardViewDelegate?
    
    // MARK: - Private properties
    
    private var bottomAnchorWordStackView = NSLayoutConstraint()
    
    /// InitialI intersection betwen collectionView and wordStackView
    enum IntersectionAnchor {
        static let initial = Grid.pt16
    }
    
    // MARK: - Subviews
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = Grid.cr12
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let collectionView: UICollectionView & ImageCollectionViewInput = {
        let collectionView = ImageCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var wordStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            sourceLabel,
            translationFiled,
            button
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutMargins = UIEdgeInsets(
            top: Grid.pt16,
            left: Grid.pt16,
            bottom: Grid.pt16,
            right: Grid.pt16
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = Grid.pt12
        stackView.axis = .vertical
        return stackView
    }()
    
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .titleBold1
        label.textAlignment = .center
        return label
    }()
    
    private let translationFiled: UITextField = {
        let textFiled = UITextField()
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        textFiled.placeholder = NSLocalizedString("Write a translation", comment: "Placeholder")
        textFiled.font = .titleBold1
        textFiled.textAlignment = .center
        textFiled.layer.cornerRadius = Grid.cr12
        textFiled.backgroundColor = .fiveBackgroundColor
        return textFiled
    }()
    
    let button: UIButton = {
        let button = UIButton(configuration: .appFilled())
        button.translatesAutoresizingMaskIntoConstraints = false
        let title = NSLocalizedString("Save", comment: "Button")
        button.setTitle(title, for: .normal)
        return button
    }()
    
    // MARK: - Constraction

    init(delegate: CardViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        backgroundColor = .systemBackground
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
    
    func selectedImage() -> UIImage? {
        return imageView.image
    }
    
    func translation() -> String? {
        translationFiled.text
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
        let bottomInset = keyboardViewEndFrame.height
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset.bottom = .zero
        } else {
            scrollView.contentInset.bottom = bottomInset
        }
        
        UIView.animate(withDuration: Grid.factor25) {
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
        collectionView.viewOutput = self
        addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(collectionView)
        scrollView.addSubview(wordStackView)
    }
    
    private func setupAppearance() {
    
    }
    
    private func setupConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            scrollView.heightAnchor.constraint(equalTo: safeArea.heightAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Grid.pt16),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Grid.pt16),
            imageView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -Grid.pt16),
            imageView.heightAnchor.constraint(equalTo: widthAnchor),
            
            collectionView.heightAnchor.constraint(equalTo: wordStackView.heightAnchor, multiplier: Grid.factor35),
            collectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Grid.pt16),
            collectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Grid.pt16),
            collectionView.bottomAnchor.constraint(equalTo: wordStackView.topAnchor),
            
            wordStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            wordStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            wordStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            wordStackView.widthAnchor.constraint(equalTo: widthAnchor),
            
            translationFiled.heightAnchor.constraint(equalToConstant: Grid.pt48),
            button.heightAnchor.constraint(equalTo: translationFiled.heightAnchor)
        ])
    }
}

extension CardView: ImageCollectionViewOutput {
    func didSelectImage(image: UIImage?) {
        imageView.image = image
    }
    
    func didTapAddImage() {
        delegate?.addImage()
    }
}

// swiftlint: enable line_length
