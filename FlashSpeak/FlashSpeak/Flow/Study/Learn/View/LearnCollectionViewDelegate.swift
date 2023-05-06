//
//  LearnCollectionViewDelegate.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 05.05.2023.
//
// swiftlint:disable line_length

import UIKit

class LearnCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    
    weak var viewController: (UIViewController & LearnViewInput)?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewController?.didSelectItemAt(index: indexPath.item)
        guard let cell = collectionView.cellForItem(at: indexPath) as? AnswerCell else { return }
        switch cell.isRight {
        case true:
            cell.backgroundColor = .systemGreen
        case false:
            cell.backgroundColor = .systemRed
        default:
            return
        }
    }
}

extension LearnCollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    
    enum Settings {
        static let itemPerRow: CGFloat = 2
        static let itemPerColumn: CGFloat = 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layoutWith = Layout.insetsCollection.left + Layout.insetsCollection.right
        let fullWidth = (viewController?.view.frame.width ?? UIScreen.main.bounds.width) - layoutWith
        let fullHeight = collectionView.frame.height
        let width = (fullWidth - (Settings.itemPerRow - 1) * Layout.separatorCollection) / Settings.itemPerRow
        let height = (fullHeight - (Settings.itemPerColumn - 1) * Layout.separatorCollection) / Settings.itemPerColumn
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Layout.separatorCollection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Layout.separatorCollection
    }
}

// swiftlint:enable line_length
