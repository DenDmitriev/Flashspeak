//
//  ListMakerCollectionViewDataSource.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 24.04.2023.
//
// swiftlint:disable line_length

import UIKit

class ListMakerCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    weak var viewController: (UIViewController & ListMakerViewInput)?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewController?.tokens.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TokenCell.identifier,
                for: indexPath
            ) as? TokenCell,
            let text = viewController?.tokens[indexPath.item]
        else { return UICollectionViewCell() }
        cell.configure(text: text)
        return cell
    }
    
}

// swiftlint:enable line_length
