//
//  ResultsCollectionViewDataSource.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 07.05.2023.
//
// swiftlint: disable line_length

import UIKit

class ResultsCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    weak var view: ResultCollectionViewProtocol?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return view?.resultViewModels.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCell.identifier, for: indexPath) as? ResultCell,
            let viewModel = view?.resultViewModels[indexPath.item]
        else { return UICollectionViewCell() }
        cell.configure(viewModel: viewModel)
        return cell
    }
    
}

// swiftlint: enable line_length
