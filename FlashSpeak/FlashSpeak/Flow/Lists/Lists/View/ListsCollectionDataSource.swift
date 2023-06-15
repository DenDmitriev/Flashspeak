//
//  ListsCollectionDataSource.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 18.04.2023.
//
// swiftlint:disable line_length

import UIKit

class ListsCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    weak var viewController: (UIViewController & ListsViewInput)?
      
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let isSearching = viewController?.isSearching ?? false
        if isSearching {
            return viewController?.serachListCellModels.count ?? 0
        } else {
            return viewController?.listCellModels.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ListCell.identifier,
                for: indexPath
            ) as? ListCell,
            let isSearching = viewController?.isSearching,
            let listCellModel = isSearching ? viewController?.serachListCellModels[indexPath.row] : viewController?.listCellModels[indexPath.row]
        else { return UICollectionViewCell() }
        let menu = menu(indexPath: indexPath)
        cell.configure(listCellModel: listCellModel, menu: menu)
        return cell
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

// swiftlint:enable line_length
