//
//  ResultsCollectionViewDelegate.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 07.05.2023.
//
// swiftlint: disable line_length

import UIKit

class ResultsCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    weak var view: ResultCollectionViewProtocol?
}

extension ResultsCollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    
    enum LayoutResult {
        static let seporator: CGFloat = Layout.separatorCollection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width = height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutResult.seporator
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutResult.seporator
    }
}

// swiftlint: enable line_length
