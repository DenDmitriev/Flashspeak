//
//  WordCardsCollectionDelegate.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//
// swiftlint:disable line_length

import UIKit

class WordCardsCollectionDelegate: NSObject, UICollectionViewDelegate {
    
    weak var viewInput: (UIViewController & WordCardsViewInput)?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewInput?.didTapWord(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        if let indexPath = indexPaths.first {
            let configuration = UIContextMenuConfiguration(actionProvider: { [weak self] _ in
                return self?.menu(indexPath: indexPath)
            })
            return configuration
        } else {
            return UIContextMenuConfiguration()
        }
    }
    
    private func menu(indexPath: IndexPath) -> UIMenu {
        let closure: (WordMenu.Action) -> Void = { [weak self] action in
            switch action {
            case .edit:
                self?.viewInput?.presenter.edit(by: indexPath)
            case .delete:
                self?.viewInput?.presenter.deleteWords(by: [indexPath])
            }
        }
        return WordMenu().menu(closure: closure)
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

// swiftlint:enable line_length
