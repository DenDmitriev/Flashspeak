//
//  ListsCollectionDelegate.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//
// swiftlint:disable line_length

import UIKit

class ListsCollectionDelegate: NSObject, UICollectionViewDelegate {
    
    weak var viewController: (UIViewController & ListsViewInput)?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewController?.didSelectList(indexPath: indexPath)
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
        let closure: (ListMenu.Action) -> Void = { [weak self] action in
            switch action {
            case .editCards:
                self?.viewController?.presenter.editList(at: indexPath)
            case .editWords:
                self?.viewController?.presenter.editWords(at: indexPath)
            case .transfer:
                self?.viewController?.presenter.transfer(at: indexPath)
            case .delete:
                self?.viewController?.presenter.deleteList(at: indexPath)
            }
        }
        return ListMenu().menu(closure: closure)
    }
}

extension ListsCollectionDelegate: UICollectionViewDelegateFlowLayout {
    
    enum Settings {
        static let itemPerRow: CGFloat = {
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                return 1
            case .pad:
                return 3
            default:
                return 1
            }
        }()
        
        static let height: CGFloat = {
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                return Grid.pt128
            case .pad:
                return Grid.pt256
            default:
                return Grid.pt128
            }
        }()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layoutWith = Layout.insetsCollection.left + Layout.insetsCollection.right
        let fullWidth = (viewController?.view.frame.width ?? UIScreen.main.bounds.width) - layoutWith
        let width = (fullWidth - (Settings.itemPerRow - 1) * Layout.separatorCollection ) / Settings.itemPerRow
        let height: CGFloat = Settings.height
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
