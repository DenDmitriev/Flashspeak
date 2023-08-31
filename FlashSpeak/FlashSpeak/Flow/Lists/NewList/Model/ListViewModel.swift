//
//  ListViewModel.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 13.06.2023.
//

import Foundation

struct ListViewModel {
    var title: String
    var style: GradientStyle
    var imageFlag: Bool
//    var inputLangCode: String
    
    static func modelFactory(list: List?) -> ListViewModel {
        let title = list?.title ?? ""
        let style = list?.style ?? .grey
        let imageFlag = list?.addImageFlag ?? true
//        let sourceLanguage = UserDefaultsHelper.source()
//        let inputLangCode = (list?.inputLang ?? sourceLanguage)?.code ?? ""
        return ListViewModel(title: title, style: style, imageFlag: imageFlag)
    }
    
    func isEquals(list: List?) -> Bool? {
        guard let list = list else { return nil }
        guard
            list.title == title,
            list.addImageFlag == imageFlag,
            list.style == style
        else { return true }
        return false
    }
}
