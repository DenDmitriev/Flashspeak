//
//  ProgressViewDataSource.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 31.05.2023.
//
// swiftlint: disable line_length

import UIKit

class ProgressViewDataSource: NSObject, UICollectionViewDataSource {

    weak var view: ProgressViewInput?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return view?.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCell.identifier, for: indexPath) as? ProgressCell
        else { return UICollectionViewCell() }
        cell.configure()
        return cell
    }
}

// swiftlint: enable line_length
