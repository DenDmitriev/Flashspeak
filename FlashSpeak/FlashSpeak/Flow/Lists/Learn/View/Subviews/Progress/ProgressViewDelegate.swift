//
//  ProgressViewDelegate.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 31.05.2023.
//
// swiftlint: disable line_length

import UIKit

class ProgressViewDelegate: NSObject, UICollectionViewDelegate {

    weak var view: ProgressViewInput?
}

extension ProgressViewDelegate: UICollectionViewDelegateFlowLayout {
    
    enum Layout {
        static let seporator = Grid.pt2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalWidth = collectionView.frame.width
        let count: CGFloat = CGFloat(view?.count ?? 1)
        var width = (totalWidth - (Layout.seporator * (count - 1))) / count
        let height = collectionView.frame.height
        if width <= height {
            width = height
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Layout.seporator
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Layout.seporator
    }
}

// swiftlint: enable line_length
