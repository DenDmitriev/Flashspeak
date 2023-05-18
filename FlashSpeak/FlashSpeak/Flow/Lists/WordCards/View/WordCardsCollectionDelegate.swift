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
        if !indexPaths.isEmpty {
            let configuration = UIContextMenuConfiguration(actionProvider: { _ in
                var menuElements = [UIMenuElement]()
                WordMenu.allCases.forEach { wordMenu in
                    let action = UIAction(title: wordMenu.title, image: wordMenu.image) { _ in
                        switch wordMenu {
                        case .delete:
                            self.viewInput?.presenter.deleteWords(by: indexPaths)
                        }
                    }
                    menuElements.append(action)
                }
                return UIMenu(children: menuElements)
            })
            return configuration
        } else {
            return UIContextMenuConfiguration()
        }
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
