//
//  CardCollectionDelegate.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 15.05.2023.
//
// swiftlint:disable line_length

import UIKit

class CardCollectionDelegate: NSObject, UICollectionViewDelegate {
    
    weak var viewController: (UIViewController & CardViewInput)?
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        viewController?.scrollDidEnd()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewController?.scrollDidEnd()
    }
    
}

extension CardCollectionDelegate: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = collectionView.frame.height
        let width: CGFloat
        guard
            let cell = collectionView.cellForItem(at: indexPath) as? ImageCell,
            let imageSize = cell.imageSize()
        else {
            width = height
            return CGSize(width: width, height: height)
        }
        let aspect = imageSize.width / imageSize.height
        width = aspect * height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}

// swiftlint:enable line_length
