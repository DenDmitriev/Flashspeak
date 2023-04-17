//
//  ListsViewController.swift
//  Lingocard
//
//  Created by Denis Dmitriev on 12.04.2023.
//

import UIKit

class ListsViewController: UIViewController {
    
    private let changeLanguageButton = ChangeLangButtonView()

    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        layoutViews()
        configure()
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

extension ListsViewController {
    func addViews() {
        view.addSubview(changeLanguageButton)
    }
    
    func layoutViews() {
        NSLayoutConstraint.activate([
            changeLanguageButton.widthAnchor.constraint(equalToConstant: 44),
            changeLanguageButton.widthAnchor.constraint(equalTo: changeLanguageButton.heightAnchor, multiplier: 4/3),
            changeLanguageButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 105),
            changeLanguageButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16)
        ])
    }
    
    func configure() {
        changeLanguageButton.translatesAutoresizingMaskIntoConstraints = false
        changeLanguageButton.setImage(UIImage(named: "unitedKingdom"), for: .normal)
        changeLanguageButton.addTarget(self, action: #selector(changeLanguage), for: .touchUpInside)
    }
    
    @objc func changeLanguage() {
        
    }
}
