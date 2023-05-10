//
//  StatisticsCollectionViewDelegate.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 10.05.2023.
//

import UIKit

class StatisticsCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    
    weak var viewController: (UIViewController & StatisticViewInput)?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function, indexPath)
    }
}
