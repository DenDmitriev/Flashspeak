//
//  WordCardsViewController.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 15.04.2023.
//

import UIKit

class WordCardsViewController: UIViewController {
    
    //Fake Data
    var words: [Word] = []
    
    init(words: [Word], title: String) {
        super.init(nibName: nil, bundle: nil)
        self.words = words
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var wordCardsView: WordCardsView {
        return self.view as! WordCardsView
    }
    
    override func loadView() {
        super.loadView()
        self.view = WordCardsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        wordCardsView.collectionView.delegate = self
        wordCardsView.collectionView.dataSource = self
        wordCardsView.collectionView.register(WordCardViewCell.self, forCellWithReuseIdentifier: WordCardViewCell.identifier)
    }
}

extension WordCardsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return words.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WordCardViewCell.identifier, for: indexPath) as? WordCardViewCell else { return UICollectionViewCell() }
        cell.configure(word: words[indexPath.item])
        return cell
    }
}

extension WordCardsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
    }
}

extension WordCardsViewController: UICollectionViewDelegateFlowLayout {
    
    enum Layout {
        static let itemsPerRow: CGFloat = 2
        static let separator: CGFloat = 16
        static let sectionInsets = UIEdgeInsets(top: 0, left: Layout.separator, bottom: 0, right: Layout.separator)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Layout.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = Layout.sectionInsets.left * (Layout.itemsPerRow + 1)
        let availableWidth = self.view.frame.width - paddingSpace
        let width = availableWidth / Layout.itemsPerRow
        let height = width
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Layout.separator
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Layout.separator
    }
}

