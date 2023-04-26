//
//  WordCardsCollectionDataSource.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import UIKit

class WordCardsCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    var viewInput: (UIViewController & WordCardsViewInput)?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewInput?.wordCardCellModels.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WordCardViewCell.identifier,
                for: indexPath
            ) as? WordCardViewCell,
            let wordCardCellModel = viewInput?.wordCardCellModels[indexPath.item],
            let style = viewInput?.style
        else { return UICollectionViewCell() }
        cell.configure(wordCardCellModel: wordCardCellModel, style: style)
        return cell
    }
}
