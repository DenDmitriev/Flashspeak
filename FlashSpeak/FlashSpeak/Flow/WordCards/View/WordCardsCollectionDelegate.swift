//
//  WordCardsCollectionDelegate.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import UIKit

class WordCardsCollectionDelegate: NSObject, UICollectionViewDelegate {
    
    var viewInput: (UIViewController & WordCardsViewInput)?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function, indexPath.item)
    }
}

extension WordCardsCollectionDelegate: UICollectionViewDelegateFlowLayout {
    
    enum Layout {
        static let itemsPerRow: CGFloat = 2
        static let separator: CGFloat = 16
        static let sectionInsets = UIEdgeInsets(top: 0, left: Layout.separator, bottom: 0, right: Layout.separator)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Layout.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = Layout.sectionInsets.left * (Layout.itemsPerRow + 1)
        let fullWidth = collectionView.frame.width
        let availableWidth = fullWidth - paddingSpace
        let width = availableWidth / Layout.itemsPerRow
        let height = width
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Layout.separator
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Layout.separator
    }
}
