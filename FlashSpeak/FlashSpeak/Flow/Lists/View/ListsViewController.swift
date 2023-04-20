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
    
    private var lists = [List]()
    
    override func loadView() {
        super.loadView()
        self.view = ListsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureButton()
        configureLanguageButton()
        createCustomBarButtonItem()
        configureCollectionView()
    }
    
    private func configureButton() {
        listsView.newListButton.addTarget(self, action: #selector(addListDidTaped(sender:)), for: .touchUpInside)
    }
    
    private func configureLanguageButton() {
        listsView.changeLanguageButton.addTarget(self, action: #selector(changeLanguage(sender:)), for: .touchUpInside)
    }
    
    private func createCustomBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: listsView.changeLanguageButton)
        
    }
      
    private func configureCollectionView() {
        listsView.collectionView.delegate = self
        listsView.collectionView.dataSource = self
        listsView.collectionView.register(ListWordsCell.self, forCellWithReuseIdentifier: ListWordsCell.identifier)
        
        //Fake data
        lists = [
            List(
                title: "Человек",
                words: [
                    Word(source: "люди", translation: "people"),
                    Word(source: "семья", translation: "family"),
                    Word(source: "женщина", translation: "women"),
                    Word(source: "мужчина", translation: "man"),
                    Word(source: "девочка", translation: "girl"),
                    Word(source: "мальчик", translation: "boy"),
                    Word(source: "ребёнок", translation: "baby"),
                    Word(source: "друг", translation: "friend"),
                    Word(source: "муж", translation: "husband"),
                    Word(source: "жена", translation: "wife"),
                    Word(source: "имя", translation: "name"),
                    Word(source: "голова", translation: "head"),
                    Word(source: "лицо", translation: "face")
                ],
                style: .red,
                created: Date.now,
                addImageFlag: true),
            List(
                title: "Время",
                words: [
                    Word(source: "жизнь", translation: "life"),
                    Word(source: "час", translation: "hour"),
                    Word(source: "неделя", translation: "week"),
                    Word(source: "день", translation: "day"),
                    Word(source: "ночь", translation: "night"),
                    Word(source: "месяц", translation: "month"),
                    Word(source: "год", translation: "year"),
                    Word(source: "время", translation: "time")
                ],
                style: .green,
                created: Date.now,
                addImageFlag: true),
            List(
                title: "Природа",
                words: [
                    Word(source: "мир", translation: "world"),
                    Word(source: "солнце", translation: "sun"),
                    Word(source: "животное", translation: "animal"),
                    Word(source: "дерево", translation: "tree"),
                    Word(source: "вода", translation: "woter"),
                    Word(source: "еда", translation: "food"),
                    Word(source: "огонь", translation: "fier")
                ],
                style: .yellow,
                created: Date.now,
                addImageFlag: true)
        ]
    }
    
    
    @objc private func addListDidTaped(sender: UIButton) {
        print(#function)
        let newListController = NewListViewController()
        newListController.modalPresentationStyle = .overFullScreen
        self.present(newListController, animated: true)
    }
    
    @objc private func changeLanguage(sender: UIButton) {
        let changeLanguageController = ChangeLanguageController()
        changeLanguageController.modalPresentationStyle = .overFullScreen
        self.present(changeLanguageController, animated: true)
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
        let list = lists[indexPath.row]
        wordCartsViewController.words = list.words
        wordCartsViewController.title = list.title
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
