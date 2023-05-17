//
//  ListMakerCollectionViewDataSource.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 24.04.2023.
//
// swiftlint:disable line_length

import UIKit

class ListMakerCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    weak var viewController: (UIViewController & ListMakerViewInput)?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case ListMakerView.Initial.tokenCollectionTag:
            return viewController?.tokens.count ?? .zero
        case ListMakerView.Initial.removeCollectionTag:
            return 1
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case ListMakerView.Initial.tokenCollectionTag:
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TokenCell.identifier,
                    for: indexPath
                ) as? TokenCell,
                let text = viewController?.tokens[indexPath.item]
            else { return UICollectionViewCell() }
            cell.configure(text: text)
            return cell
        case ListMakerView.Initial.removeCollectionTag:
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ButtonCell.identifier,
                    for: indexPath
                ) as? ButtonCell
            else { return UICollectionViewCell() }
            let image = UIImage(systemName: "trash")
            cell.configure(image: image)
            cell.button.addTarget(self, action: #selector(removeDidTap(sender:)), for: .touchUpInside)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    @objc func removeDidTap(sender: UIButton) {
        viewController?.clearField()
    }
    
}

// swiftlint:enable line_length
