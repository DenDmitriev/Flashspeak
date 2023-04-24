//
//  ListMakerPresenter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 21.04.2023.
//

import UIKit
import Combine

protocol ListMakerViewInput {
    var tokens: [String] { get set }
    func hideRemoveArea(isHidden: Bool)
    func updateRemoveArea(isActive: Bool)
    func deleteToken(token: String)
    func deleteToken(indexPaths: [IndexPath])
    func addToken(token: String)
    var tokenCollection: UICollectionView? { get }
    var removeCollection: UICollectionView? { get }
}

protocol ListMakerViewOutput {
    var list: List { get set }
    func generateList(words: [String])
}

class ListMakerPresenter {
    
    var list: List
    
    var viewController: (UIViewController & ListMakerViewInput)?
    
    init(list: List) {
        self.list = list
    }
}

extension ListMakerPresenter: ListMakerViewOutput {
    
    
    func generateList(words: [String]) {
        // place for reqest for translate
        print(#function, words)
    }
}
