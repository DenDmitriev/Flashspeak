//
//  WordCartsViewController.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 15.04.2023.
//

import UIKit

class WordCartsViewController: UIViewController {
    
    //Before CoreData models not created
    struct Word {
        var id: UUID
        var source: String
        var translation: String
        var imageURL: URL?
    }
    
    //Fake Data
    var words: [Word] = [
        Word(id: UUID(), source: "Машина", translation: "Car", imageURL: URL(string: "car")),
        Word(id: UUID(), source: "Бумага", translation: "Paper", imageURL: URL(string: "paper")),
        Word(id: UUID(), source: "Ручка", translation: "Pen", imageURL: URL(string: "pen")),
        Word(id: UUID(), source: "Дверь", translation: "Door", imageURL: URL(string: "door")),
        Word(id: UUID(), source: "Стул", translation: "Chair", imageURL: URL(string: "chair")),
        Word(id: UUID(), source: "Стол", translation: "Table", imageURL: URL(string: "table")),
        Word(id: UUID(), source: "Деньги", translation: "Money", imageURL: URL(string: "money"))
    ]
    
    private var wordCartsView: WordCartsView {
        return self.view as! WordCartsView
    }
    
    override func loadView() {
        super.loadView()
        self.view = WordCartsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        wordCartsView.collectionView.delegate = self
        wordCartsView.collectionView.dataSource = self
        wordCartsView.collectionView.register(WordCartViewCell.self, forCellWithReuseIdentifier: WordCartViewCell.identifier)
    }
}

extension WordCartsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return words.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WordCartViewCell.identifier, for: indexPath) as? WordCartViewCell else { return UICollectionViewCell() }
        cell.configure(word: words[indexPath.item])
        return cell
    }
}

extension WordCartsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
    }
}

extension WordCartsViewController: UICollectionViewDelegateFlowLayout {
    
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

