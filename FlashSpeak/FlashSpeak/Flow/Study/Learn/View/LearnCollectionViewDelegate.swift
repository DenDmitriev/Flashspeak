//
//  LearnCollectionViewDelegate.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 05.05.2023.
//
// swiftlint:disable line_length

import UIKit

class LearnCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    
    weak var viewController: (UIViewController & LearnViewInput)?
    var answerType: LearnSettings.Answer?
    
    private lazy var itemPerRow: CGFloat = {
        switch answerType {
        case .test:
            return 2
        case .keyboard:
            return 1
        default:
            return 1
        }
    }()
    
    private lazy var itemPerColumn: CGFloat = {
        switch answerType {
        case .test:
            return 3
        case .keyboard:
            return 2
        default:
            return 1
        }
    }()
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch answerType {
        case .test:
            viewController?.testDidAnswer(index: indexPath.item)
        default:
            return
        }
    }
}

extension LearnCollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let layoutWith = Layout.insetsCollection.left + Layout.insetsCollection.right
        let fullWidth = (viewController?.view.frame.width ?? UIScreen.main.bounds.width) - layoutWith
        let fullHeight = collectionView.frame.height
        
        let width = (fullWidth - (itemPerRow - 1) * Layout.separatorCollection) / itemPerRow
        let height = (fullHeight - (itemPerColumn - 1) * Layout.separatorCollection) / itemPerColumn
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Layout.separatorCollection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Layout.separatorCollection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch answerType {
        case .keyboard:
            if section == 1 {
                return UIEdgeInsets(top: Grid.pt8, left: .zero, bottom: .zero, right: .zero)
            } else {
                return UIEdgeInsets()
            }
            
        default:
            return UIEdgeInsets()
        }
        
    }
}

// swiftlint:enable line_length
