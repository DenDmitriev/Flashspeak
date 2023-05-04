//
//  ListMakerCollectionViewDelegate.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 24.04.2023.
//
// swiftlint:disable line_length

import UIKit

class ListMakerCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    
    weak var viewController: (UIViewController & ListMakerViewInput)?
    
}

extension ListMakerCollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Grid.pt8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Grid.pt8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.font = TokenCell().tokenLabel.font
        label.text = viewController?.tokens[indexPath.item]
        label.sizeToFit()
        return CGSize(width: label.frame.width + Grid.pt16, height: label.frame.height + Grid.pt8)
    }
}

// swiftlint:enable line_length
