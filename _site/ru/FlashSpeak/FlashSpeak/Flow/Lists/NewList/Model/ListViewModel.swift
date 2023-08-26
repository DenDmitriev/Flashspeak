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
    
    static func modelFactory(list: List?) -> ListViewModel {
        let title = list?.title ?? ""
        let style = list?.style ?? .grey
        let imageFlag = list?.addImageFlag ?? true
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
