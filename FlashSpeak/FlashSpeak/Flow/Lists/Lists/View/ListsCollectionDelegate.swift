//
//  ListsCollectionDelegate.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import UIKit

class ListsCollectionDelegate: NSObject, UICollectionViewDelegate {
    
    var viewController: (UIViewController & ListsViewInput)?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewController?.didSelectList(indexPath: indexPath)
    }
}

extension ListsCollectionDelegate: UICollectionViewDelegateFlowLayout {
    enum Layout {
        static let itemPerRow: CGFloat = 1
        static let separator: CGFloat = 16
        static let insets = UIEdgeInsets(top: 0, left: separator, bottom: 0, right: separator)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let fullWidth = viewController?.view.frame.width ?? UIScreen.main.bounds.width
        let width = fullWidth - (Layout.itemPerRow + 1) * Layout.separator
        let height: CGFloat = 128
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Layout.separator
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Layout.separator
    }
}
