//
//  ListsViewController.swift
//  Lingocard
//
//  Created by Denis Dmitriev on 12.04.2023.
//

import UIKit

class ListsViewController: UIViewController {
    
    private var listsView: ListsView {
        return self.view as! ListsView
    }
    
    private var lists = [ListWords]()
    
    override func loadView() {
        super.loadView()
        self.view = ListsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureButton()
        configureCollectionView()
    }
    
    private func configureButton() {
        listsView.newListButton.addTarget(self, action: #selector(addListDidTaped(sender:)), for: .touchUpInside)
    }
    
    private func configureCollectionView() {
        listsView.collectionView.delegate = self
        listsView.collectionView.dataSource = self
        listsView.collectionView.register(ListWordsCell.self, forCellWithReuseIdentifier: ListWordsCell.identifier)
        
        //Fake data
        lists = [
            ListWords(title: "Человек", words: ["люди", "семья", "женщина", "мужчина", "девочка", "мальчик", "ребёнок", "друг", "муж", "жена", "имя", "голова", "лицо"], sourceLang: .russian, targetLang: .english, style: .red),
            ListWords(title: "Время", words: ["жизнь", "час", "неделя", "день", "ночь", "месяц", "год", "время"], sourceLang: .russian, targetLang: .english, style: .green),
            ListWords(title: "Природа", words: ["мир", "солнце", "животное", "дерево", "вода", "еда", "огонь"], sourceLang: .russian, targetLang: .english, style: .yellow)
        ]
    }
    
    
    @objc private func addListDidTaped(sender: UIButton) {
        print(#function)
    }

}

extension ListsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListWordsCell.identifier, for: indexPath) as? ListWordsCell else { return UICollectionViewCell() }
        cell.configure(listWors: lists[indexPath.row])
        return cell
    }
}

extension ListsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
        
        //Fake data in list
        let wordCartsViewController = WordCartsViewController()
        wordCartsViewController.title = lists[indexPath.row].title
        navigationController?.pushViewController(wordCartsViewController, animated: true)
    }
}

extension ListsViewController: UICollectionViewDelegateFlowLayout {
    
    enum Layout {
        static let itemPerRow: CGFloat = 1
        static let separator: CGFloat = 16
        static let insets = UIEdgeInsets(top: 0, left: separator, bottom: 0, right: separator)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width - (Layout.itemPerRow + 1) * Layout.separator
        let height: CGFloat = 128
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Layout.separator
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Layout.separator
    }
}
