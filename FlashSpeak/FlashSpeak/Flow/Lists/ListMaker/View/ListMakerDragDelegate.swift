//
//  ListMakerDragDelegate.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 24.04.2023.
//
// swiftlint:disable line_length

import UIKit

class ListMakerDragDelegate: NSObject, UICollectionViewDragDelegate {
    
    weak var viewController: (UIViewController & ListMakerViewInput)?
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let item = viewController?.tokens[indexPath.item] else { return [] }
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        // Unlock remove area
        viewController?.hideRemoveArea(isHidden: false)
        return [dragItem]
    }
}

// swiftlint:enable line_length
