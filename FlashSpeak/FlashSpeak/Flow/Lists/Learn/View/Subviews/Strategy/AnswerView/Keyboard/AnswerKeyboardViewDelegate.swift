//
//  AnswerKeyboardViewDelegate.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 19.05.2023.
//
// swiftlint:disable line_length

import UIKit

class AnswerKeyboardViewDelegate: NSObject, UICollectionViewDelegate {
    
    weak var view: AnswerKeyboardViewStrategy?
    
}

extension AnswerKeyboardViewDelegate: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let fullWidth = view?.collectionView.frame.width ?? UIScreen.main.bounds.width
        
        let width: CGFloat = fullWidth
        let height: CGFloat = AnswerKeyboardViewStrategy.height
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == AnswerKeyboardViewStrategy.buttonSection {
            var edgeInsets = UIEdgeInsets()
            edgeInsets.top = Grid.pt8
            return edgeInsets
        } else {
            return UIEdgeInsets()
        }
    }
}

// swiftlint:enable line_length
