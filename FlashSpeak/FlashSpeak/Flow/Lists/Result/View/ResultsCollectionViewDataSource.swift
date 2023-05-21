//
//  ResultsCollectionViewDataSource.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 07.05.2023.
//
// swiftlint: disable line_length

import UIKit

class ResultsCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    weak var viewController: (UIViewController & ResultViewInput)?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewController?.resultViewModels.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCell.identifier, for: indexPath) as? ResultCell,
            let viewModel = viewController?.resultViewModels[indexPath.item]
        else { return UICollectionViewCell() }
        cell.configure(viewModel: viewModel)
        
        return cell
    }
    
}

// swiftlint: enable line_length
