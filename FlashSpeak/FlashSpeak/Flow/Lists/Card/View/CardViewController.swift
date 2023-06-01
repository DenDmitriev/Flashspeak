//
//  CardViewController.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 15.05.2023.
//

import UIKit

class CardViewController: UIViewController {
    
    // MARK: - Properties
    
    var cardViewModel: CardViewModel?
    
    // MARK: - Private properties
    
    private var imagePicker = UIImagePickerController()
    private var cardView: CardView {
        return view as? CardView ?? CardView(delegate: self)
    }
    
    private let presenter: CardViewOutput
    
    
    // MARK: - Constraction
    
    init(presenter: CardViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        view = CardView(delegate: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureButton()
        presenter.subscribe()
        imagePicker.delegate = self
    }
    
    // MARK: - Private functions
    
    private func configureCollectionView() {
    }
    
    private func configureButton() {
        cardView.button.addTarget(self, action: #selector(saveDidTap(sender:)), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc func saveDidTap(sender: UIButton) {
        guard
            let translation = cardView.translation(),
            let index = cardView.collectionView.indexPathsForSelectedItems?.last?.item,
            let image = cardViewModel?.images[index]
        else { return }
        presenter.save(translation: translation, image: image)
    }

}

extension CardViewController: CardViewInput {

    func configureView(style: GradientStyle) {
        cardView.style = style
        cardView.configureView(model: cardViewModel)
    }
    
    func insertImage(image: UIImage, at index: Int) {
        cardView.collectionView.performBatchUpdates {
            let indexPath: IndexPath
            if index == .zero {
                // Default image at first
                cardView.imageView.image = image
                cardViewModel?.images.insert(image, at: .zero)
                cardView.collectionView.images.insert(image, at: .zero)
                indexPath = IndexPath(item: index, section: .zero)
            } else {
                indexPath = IndexPath(item: cardViewModel?.images.count ?? .zero, section: .zero)
                cardViewModel?.images.append(image)
                cardView.collectionView.images.append(image)
            }
            cardView.collectionView.insertItems(at: [indexPath])
        }
        if index == .zero {
            cardView.collectionView.selectItem(
                at: IndexPath(item: index, section: .zero),
                animated: true,
                scrollPosition: .top
            )
        }
    }
    
    func didTapAddImage() {
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true)
    }
}

extension CardViewController: CardViewDelegate {
    
    func addImage() {
        didTapAddImage()
    }
}

extension CardViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // swiftlint: disable line_length
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        var newImage: UIImage
        
        if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        cardView.imageView.image = newImage
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    // swiftlint: enable line_length
}
