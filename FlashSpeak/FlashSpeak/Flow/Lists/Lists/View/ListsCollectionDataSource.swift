//
//  ListsCollectionDataSource.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 18.04.2023.
//
// swiftlint:disable all

import UIKit

class ListsCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    var viewController: ListsViewController?
    
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
