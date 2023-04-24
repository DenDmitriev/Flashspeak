//
//  ListsCollectionDataSource.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 18.04.2023.
//

import UIKit

class ListsCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    var viewController: ListsViewController?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewController?.lists.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.identifier, for: indexPath) as? ListCell,
            let list = viewController?.lists[indexPath.row]
        else { return UICollectionViewCell() }
        cell.configure(list: list)
        return cell
    }
}
