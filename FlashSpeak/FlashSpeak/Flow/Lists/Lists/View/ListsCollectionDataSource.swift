//
//  ListsCollectionDataSource.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 18.04.2023.
//
// swiftlint:disable line_length

import UIKit

class ListsCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    weak var viewController: (UIViewController & ListsViewInput)?
      
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewController?.listCellModels.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ListCell.identifier,
                for: indexPath
            ) as? ListCell,
            let listCellModel = viewController?.listCellModels[indexPath.row]
        else { return UICollectionViewCell() }
        cell.configure(listCellModel: listCellModel)
        return cell
    }
    
}

// swiftlint:enable line_length
