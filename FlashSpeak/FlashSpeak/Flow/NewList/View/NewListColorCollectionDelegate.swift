//
//  NewListColorCollectionDelegate.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import UIKit

class NewListColorCollectionDelegate: NSObject, UICollectionViewDelegate {
    
    var viewInput: (UIViewController & NewListViewInput)?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Get selected style
        // styleList = GradientStyle.allCases[indexPath.item]
    }
}

extension NewListColorCollectionDelegate: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemCount = CGFloat(GradientStyle.allCases.count)
        let spaceWidth = collectionView.frame.width - (itemCount - 1) * Grid.pt8
        let width = spaceWidth / itemCount
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Grid.pt8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Grid.pt8
    }
}
