//
//  NewListColorCollectionDataSource.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import UIKit

class NewListColorCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GradientStyle.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as? ColorCell else { return UICollectionViewCell() }
        let style = GradientStyle.allCases[indexPath.item]
        cell.configure(style: style)
        if style == .grey {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        }
        return cell
    }

    
}
