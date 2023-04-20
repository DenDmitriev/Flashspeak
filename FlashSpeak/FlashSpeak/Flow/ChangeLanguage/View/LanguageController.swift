//
//  ChangeLanguageController.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 17.04.2023.
//

import UIKit

class LanguageController: UIViewController {
    
    private var languageTableDataSource: UITableViewDataSource?
    private var languageTableDelegate: UITableViewDelegate?
    
    private var languageView: LanguageView {
        return self.view as! LanguageView
    }
    
    override func loadView() {
        super.loadView()
        self.view = LanguageView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureGesture()
        // Do any additional setup after loading the view.
    }
    
    private func configureTableView() {
        self.languageView.tableView.dataSource = languageTableDataSource
        self.languageView.tableView.delegate = languageTableDelegate
    }
    
    private func configureGesture() {
        let tapBackground = UITapGestureRecognizer(target: self, action: #selector(didTapBackroundView(sender:)))
        tapBackground.delegate = self
        self.languageView.addGestureRecognizer(tapBackground)
    }
    
    //MARK: - Actions
    
    @objc private func didTapBackroundView(sender: UIView) {
        self.dismiss(animated: true)
    }
    
    func didSelectItem(item: Int) {
        let selectedLanguage = Language.allCases[item]
        
        //Change user study course here
        print("selected language \(selectedLanguage)")
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.dismiss(animated: true)
        }
    }

}


extension LanguageController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        didSelectItem(item: indexPath.item)
    }
}

extension LanguageController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}
