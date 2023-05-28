//
//  MistakeCollectionViewDataSource.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 27.05.2023.
//

import UIKit

class MistakeCollectionViewDataSource: NSObject, UICollectionViewDataSource {

    weak var view: MistakeCollectionViewProtocol?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return view?.mistakeViewModels.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WordCell.identifier, for: indexPath) as? WordCell,
            let viewModel = view?.mistakeViewModels[indexPath.item]
        else { return UICollectionViewCell() }
        cell.configure(viewModel: viewModel)
        return cell
    }
}
