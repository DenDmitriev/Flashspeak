//
//  NewListColorCollectionDataSource.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import UIKit

class NewListColorCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    var viewInput: (UIViewController & NewListViewInput)?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewInput?.styles.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ColorCell.identifier,
                for: indexPath
            ) as? ColorCell,
            let style = viewInput?.styles[indexPath.item]
        else { return UICollectionViewCell() }
        
        cell.configure(style: style)
        if style == viewInput?.styleList {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        }
        return cell
    }

    
}
