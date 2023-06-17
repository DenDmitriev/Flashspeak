//
//  WordCardsCollectionDataSource.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//
// swiftlint:disable line_length

import UIKit

class WordCardsCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    weak var viewInput: (UIViewController & WordCardsViewInput)?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewInput?.isSearching ?? false {
            return viewInput?.searchingWordCardCellModels.count ?? 0
        } else {
            return viewInput?.wordCardCellModels.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WordCardViewCell.identifier,
                for: indexPath
            ) as? WordCardViewCell,
            let wordCardCellModel = (viewInput?.isSearching ?? false) ?
                viewInput?.searchingWordCardCellModels[indexPath.item] :
                    viewInput?.wordCardCellModels[indexPath.item],
            let style = viewInput?.style
        else { return UICollectionViewCell() }
        let menu = menu(indexPath: indexPath)
        cell.configure(wordCardCellModel: wordCardCellModel, style: style, menu: menu, imageFlag: viewInput?.imageFlag ?? false)
        return cell
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

// swiftlint:enable line_length
