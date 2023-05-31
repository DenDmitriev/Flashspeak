//
//  ImageCollectionDataSource.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 15.05.2023.
//
// swiftlint:disable line_length

import UIKit

class ImageCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    weak var view: ImageCollectionViewInput?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return view?.images.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell,
            let image = view?.images[indexPath.item]
        else { return UICollectionViewCell() }
        cell.configure(image: image)
        return cell
    }
}

// swiftlint:enable line_length
