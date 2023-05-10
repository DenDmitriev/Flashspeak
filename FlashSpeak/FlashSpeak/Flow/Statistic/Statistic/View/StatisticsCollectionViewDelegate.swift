//
//  StatisticsCollectionViewDelegate.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 10.05.2023.
//
// swiftlint: disable line_length

import UIKit

class StatisticsCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    
    weak var viewController: (UIViewController & StatisticViewInput)?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function, indexPath)
    }
}

extension StatisticsCollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    enum LayoutStatistic {
        static let itemPerRow: CGFloat = 2
        static let seporator: CGFloat = Layout.separatorCollection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.frame.width
        let height = Grid.pt48
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let spaceWidth = collectionView.frame.width - (LayoutStatistic.itemPerRow - 1) * LayoutStatistic.seporator
        let width = spaceWidth / LayoutStatistic.itemPerRow
        
        let height = width
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutStatistic.seporator
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutStatistic.seporator
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: .zero, left: .zero, bottom: Grid.pt16, right: .zero)
    }
}

// swiftlint: enable line_length
