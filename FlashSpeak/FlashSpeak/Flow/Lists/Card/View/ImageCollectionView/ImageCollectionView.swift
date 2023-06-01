//
//  ImageCollectionView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 31.05.2023.
//
// swiftlint:disable weak_delegate

import UIKit

protocol ImageCollectionViewInput: AnyObject {
    var images: [UIImage] { get set }
    var viewOutput: ImageCollectionViewOutput? { get set }
    
    func didSelectImage(indexPath: IndexPath)
    func didTapAddImage()
}

protocol ImageCollectionViewOutput: AnyObject {
    func didSelectImage(image: UIImage?)
}

class ImageCollectionView: UICollectionView {
    
    // MARK: - Properties
    var images = [UIImage]()
    weak var viewOutput: ImageCollectionViewOutput?
    
    // MARK: - Private properties
    private let imageCollectionDataSource: UICollectionViewDataSource?
    private let imageCollectionDelegate: UICollectionViewDelegate?

    // MARK: - Constraction
    
    init() {
        let collectionViewDelegate = ImageCollectionDelegate()
        let collectionViewDataSource = ImageCollectionDataSource()
        self.imageCollectionDataSource = collectionViewDataSource
        self.imageCollectionDelegate = collectionViewDelegate
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        collectionViewDelegate.view = self
        collectionViewDataSource.view = self
        configure() 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    private func configure() {
        showsHorizontalScrollIndicator = false
        backgroundColor = .clear
        delegate = imageCollectionDelegate
        dataSource = imageCollectionDataSource
        register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        register(AddImageCell.self, forCellWithReuseIdentifier: AddImageCell.identifier)
    }

}

extension ImageCollectionView: ImageCollectionViewInput {
    func didSelectImage(indexPath: IndexPath) {
        viewOutput?.didSelectImage(image: images[indexPath.item])
    }
    
    func didTapAddImage() {
        <#code#>
    }
}

// swiftlint:enable weak_delegate
