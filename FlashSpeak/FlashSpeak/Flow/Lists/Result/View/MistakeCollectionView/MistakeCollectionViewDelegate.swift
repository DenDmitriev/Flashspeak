//
//  MistakeCollectionViewDelegate.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 27.05.2023.
//

import UIKit

class MistakeCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    weak var view: MistakeCollectionViewProtocol?
}

extension MistakeCollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    
    enum LayoutResult {
        static let seporator: CGFloat = Layout.separatorCollection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        var width = height * 1.6
        
        let sourceLabel = UILabel(frame: CGRect.zero)
        sourceLabel.font = WordCell().sourceLabel.font
        sourceLabel.text = view?.mistakeViewModels[indexPath.item].source
        sourceLabel.sizeToFit()
        let sourceWidth = sourceLabel.frame.width
        
        let translationLabel = UILabel(frame: CGRect.zero)
        translationLabel.font = WordCell().translationLabel.font
        translationLabel.text = view?.mistakeViewModels[indexPath.item].translation
        translationLabel.sizeToFit()
        let translationWidth = translationLabel.frame.width
        
        width = translationWidth > sourceWidth ? translationWidth : sourceWidth
        width += WordCell().stackView.layoutMargins.left
        width += WordCell().stackView.layoutMargins.right
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutResult.seporator
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutResult.seporator
    }
}
