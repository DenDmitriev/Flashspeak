//
//  ChangeLanguageController.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 17.04.2023.
//

import UIKit

class ChangeLanguageController: UIViewController {
    
    private var changeLanguageView: ChangeLanguageView {
        return self.view as! ChangeLanguageView
    }
    
    override func loadView() {
        super.loadView()
        self.view = ChangeLanguageView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureGesture()
        // Do any additional setup after loading the view.
    }
    
    private func configureTableView() {
        self.changeLanguageView.tableView.dataSource = self
        self.changeLanguageView.tableView.delegate = self
    }
    
    private func configureGesture() {
        let tapBackground = UITapGestureRecognizer(target: self, action: #selector(didTapBackroundView(sender:)))
        tapBackground.delegate = self
        self.changeLanguageView.addGestureRecognizer(tapBackground)
    }
    
    //MARK: - Actions
    
    @objc private func didTapBackroundView(sender: UIView) {
        self.dismiss(animated: true)
    }

}

extension ChangeLanguageController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Language.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LanguageCell.identifier, for: indexPath) as? LanguageCell else { return UITableViewCell() }
        
        let language = Language.allCases[indexPath.row]
        cell.configure(language: language)
        
        //Replace code for get user study language here
        if language.code == "en" {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .bottom)
        }
        
        return cell
    }
}

extension ChangeLanguageController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        let selectedLanguage = Language.allCases[indexPath.item]
        
        //Change user study course here
        print("selected language \(selectedLanguage)")
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.dismiss(animated: true)
        }
    }
}

extension ChangeLanguageController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}
