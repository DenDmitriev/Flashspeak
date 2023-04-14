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
        configureTableView()
    }
    
    private func configureButton() {
        listsView.newListButton.addTarget(self, action: #selector(addListDidTaped(sender:)), for: .touchUpInside)
    }
    
    private func configureTableView() {
        listsView.tableView.register(ListWordsCell.self, forCellReuseIdentifier: ListWordsCell.identifier)
        listsView.tableView.delegate = self
        listsView.tableView.dataSource = self
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ListsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListWordsCell.identifier, for: indexPath) as? ListWordsCell else { return UITableViewCell() }
        let list = lists[indexPath.item]
        cell.configure(listWors: list)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("taped \(indexPath.row)")
    }
    
}
