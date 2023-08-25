//
//  ImageCollectionDataSource.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 15.05.2023.
//
// swiftlint:disable line_length

import UIKit

class ImageCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    enum StaticCell {
        static let count: Int = 1
    }
    
    weak var view: ImageCollectionViewInput?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cellsCount = view?.images.count ?? .zero
        return cellsCount + StaticCell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == view?.images.count ?? .zero {
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddImageCell.identifier, for: indexPath) as? AddImageCell
            else { return UICollectionViewCell() }
            cell.button.addTarget(self, action: #selector(addImage(sender:)), for: .touchUpInside)
            return cell
        } else {
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell,
                let image = view?.images[indexPath.item]
            else { return UICollectionViewCell() }
            cell.configure(image: image)
            return cell
        }
    }
    
    @objc func addImage(sender: UIButton) {
        view?.didTapAddImage()
    }
}

// swiftlint:enable line_length
