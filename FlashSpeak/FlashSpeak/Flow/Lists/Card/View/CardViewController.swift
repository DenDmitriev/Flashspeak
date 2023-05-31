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
    
    private var cardView: CardView {
        return view as? CardView ?? CardView()
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
        view = CardView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureButton()
        presenter.subscribe()
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
}
