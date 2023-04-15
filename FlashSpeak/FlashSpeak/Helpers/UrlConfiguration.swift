//
//  UrlConfiguration.swift
//  FlashSpeak
//
//  Created by Алексей Ходаков on 14.04.2023.
//

import Foundation

class UrlConfiguration {
    
    static let shared = UrlConfiguration()
    
    func translateUrl(listWords: ListWords) -> URL?  {
        guard let folderId = Bundle.main.infoDictionary?["FOLDER_ID"] as? String else { return nil }
        let words = listWords.words.joined(separator: ",")
        let queryItems = [URLQueryItem(name: "folderId", value: folderId),
                          URLQueryItem(name: "words", value: words),
                          URLQueryItem(name: "targetLanguage", value: listWords.targetLang.rawValue),
                          URLQueryItem(name: "sourceLanguage", value: listWords.sourceLang.rawValue)]
        var urlComps = URLComponents(string: "https://functions.yandexcloud.net/d4edekrnjuqtc7cudnj4?")!
        urlComps.queryItems = queryItems
        let result = urlComps.url
        return result
    }
}
