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
    private let imageCollectionDataSource: UICollectionViewDataSource?
    private let imageCollectionDelegate: UICollectionViewDelegate?
    
    
    // MARK: - Constraction
    
    init(
        presenter: CardViewOutput,
        collectionDataSource: UICollectionViewDataSource?,
        collectionDelegate: UICollectionViewDelegate?
    ) {
        self.presenter = presenter
        self.imageCollectionDataSource = collectionDataSource
        self.imageCollectionDelegate = collectionDelegate
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
        cardView.collectionView.delegate = imageCollectionDelegate
        cardView.collectionView.dataSource = imageCollectionDataSource
        cardView.collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
    }
    
    private func configureButton() {
        cardView.button.addTarget(self, action: #selector(saveDidTap(sender:)), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc func saveDidTap(sender: UIButton) {
        guard
            let index = cardView.currentIndexPath(),
            let translation = cardView.translation(),
            let image = cardViewModel?.images[index]
        else { return }
        presenter.save(translation: translation, image: image)
    }

}

extension CardViewController: CardViewInput {

    func configureView(style: GradientStyle) {
        cardView.tabBarHeight = tabBarController?.tabBar.frame.height
        cardView.style = style
        cardView.configureView(model: cardViewModel)
    }
    
    func insertImage(image: UIImage, at index: Int) {
        cardView.collectionView.performBatchUpdates {
            let indexPath: IndexPath
            if index == .zero {
                // Default image at first
                cardViewModel?.images.insert(image, at: .zero)
                indexPath = IndexPath(item: index, section: .zero)
            } else {
                indexPath = IndexPath(item: cardViewModel?.images.count ?? .zero, section: .zero)
                cardViewModel?.images.append(image)
            }
            cardView.collectionView.insertItems(at: [indexPath])
        }
    }
    
    func scrollDidEnd() {
        guard
            let centerIndexPath = cardView.getCentralIndexPath()
        else { return }
        
        cardView.collectionView.scrollToItem(at: centerIndexPath, at: .left, animated: true)
    }
}
