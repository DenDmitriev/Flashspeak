//
//  UrlConfiguration.swift
//  FlashSpeak
//
//  Created by Алексей Ходаков on 14.04.2023.
//

import Foundation

class UrlConfiguration {
    
    static let shared = UrlConfiguration()
    
    func translateUrl(list: List, study: Study) -> URL?  {
        guard let folderId = Bundle.main.infoDictionary?["FOLDER_ID"] as? String else { return nil }
        let words = list.words.map({ $0.source }).joined(separator: ",")
        let queryItems = [URLQueryItem(name: "folderId", value: folderId),
                          URLQueryItem(name: "words", value: words),
                          URLQueryItem(name: "targetLanguage", value: study.targetLanguage.code),
                          URLQueryItem(name: "sourceLanguage", value: study.sourceLanguage.code)]
        var urlComps = URLComponents(string: "https://functions.yandexcloud.net/d4edekrnjuqtc7cudnj4?")!
        urlComps.queryItems = queryItems
        let result = urlComps.url
        return result
    }
}
