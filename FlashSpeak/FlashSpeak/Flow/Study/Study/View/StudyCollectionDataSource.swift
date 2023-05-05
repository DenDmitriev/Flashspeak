//
//  StudyCollectionDataSource.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 27.04.2023.
//
// swiftlint:disable line_length

import UIKit

class StudyCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    weak var viewInput: (UIViewController & StudyViewInput)?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewInput?.studyCellModels.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: StudyCell.identifier,
                for: indexPath
            ) as? StudyCell,
            let studyCellModel = viewInput?.studyCellModels[indexPath.row]
        else { return UICollectionViewCell() }
        cell.configure(studyCellModel: studyCellModel)
        return cell
    }
    
}

// swiftlint:enable line_length
