//
//  NewListPresenter.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import UIKit

protocol NewListViewInput {
    func dissmisView()
    func createList(title: String, style: GradientStyle, imageFlag: Bool)
}

protocol NewListViewOutput {
    func close()
    func newList(title: String, style: GradientStyle, imageFlag: Bool)
}

class NewListPresenter {
    
    var viewInput: (UIViewController & NewListViewInput)?
}

extension NewListPresenter: NewListViewOutput {
    
    func close() {
        viewInput?.dismiss(animated: true)
    }
    
    func newList(title: String, style: GradientStyle, imageFlag: Bool) {
        let list = List(
            title: title,
            words: [],
            style: style,
            created: Date.now,
            addImageFlag: imageFlag
        )
        print(#function, list)
        saveListToCD(list)
        
        //go to new lust creator
        //viewInput?.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
        viewInput?.dismiss(animated: true)
    }
    
    private func saveListToCD(_ list: List) {
        let coreData = CoreDataManager.instance
        if let studies = coreData.studies,
           !studies.isEmpty {
            coreData.createList(list, for: studies[0])
        } else {
            coreData.createStudy(Study(sourceLanguage: .russian, targerLanguage: .english))
            if let studies = coreData.studies {
                coreData.createList(list, for: studies[0])
            }
        }
    }
}
