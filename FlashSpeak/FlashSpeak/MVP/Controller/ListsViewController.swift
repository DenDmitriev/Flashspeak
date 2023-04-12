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
    
    override func loadView() {
        super.loadView()
        self.view = ListsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureButton()
    }
    
    private func configureButton() {
        listsView.newListButton.addTarget(self, action: #selector(addListDidTaped(sender:)), for: .touchUpInside)
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
