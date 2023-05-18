//
//  ResultsCollectionViewDelegate.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 07.05.2023.
//
// swiftlint: disable line_length

import UIKit

class ResultsCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    weak var viewController: (UIViewController & ResultViewInput)?
}

extension ResultsCollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    
    enum LayoutResult {
        static let itemPerRow: CGFloat = 1
        static let seporator: CGFloat = Layout.separatorCollection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let spaceWidth = collectionView.frame.width - (LayoutResult.itemPerRow - 1) * LayoutResult.seporator
        let width = spaceWidth / LayoutResult.itemPerRow
        
        let resultLabelHeight = sizeToFit(text: viewController?.resultViewModels[indexPath.item].result ?? "", font: ResultCell().resultLabel.font).height
        let descriptionLabelHeight = sizeToFit(text: viewController?.resultViewModels[indexPath.item].description ?? "", font: ResultCell().descriptionLabel.font).height
        let height: CGFloat = resultLabelHeight + descriptionLabelHeight
        
        return CGSize(width: width, height: height)
    }
    
    private func sizeToFit(text: String, font: UIFont) -> CGRect {
        let label = UILabel(frame: CGRect.zero)
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutResult.seporator
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutResult.seporator
    }
}

// swiftlint: enable line_length
