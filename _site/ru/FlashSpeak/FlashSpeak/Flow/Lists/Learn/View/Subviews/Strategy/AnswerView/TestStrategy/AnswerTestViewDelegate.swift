//
//  AnswerTestViewDelegate.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 19.05.2023.
//
// swiftlint:disable line_length

import UIKit

class AnswerTestViewDelegate: NSObject, UICollectionViewDelegate {
    
    weak var view: AnswerTestViewStrategy?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view?.didAnswer(indexPath: indexPath)
    }
}

extension AnswerTestViewDelegate: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let fullWidth = view?.collectionView.frame.width ?? UIScreen.main.bounds.width
        
        let width: CGFloat = (fullWidth - (AnswerTestViewStrategy.itemPerRow - 1) * AnswerTestViewStrategy.separator) / AnswerTestViewStrategy.itemPerRow
        let height: CGFloat = AnswerTestViewStrategy.height
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return AnswerTestViewStrategy.separator
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return AnswerTestViewStrategy.separator
    }
}

// swiftlint:enable line_length
