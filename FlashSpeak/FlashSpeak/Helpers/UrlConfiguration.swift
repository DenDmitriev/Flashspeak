//
//  UrlConfiguration.swift
//  FlashSpeak
//
//  Created by Алексей Ходаков on 14.04.2023.
//

import Foundation

class UrlConfiguration {
    
    // MARK: - Properties
    static let shared = UrlConfiguration()
    
    // MARK: - Public functions
    func translateUrl(words: [String], targetLang: Language, sourceLang: Language) -> URL?  {
        guard let folderId = Bundle.main.object(forInfoDictionaryKey: "FOLDER_ID") else { return nil }
        print(folderId)
        let wordsStr = words.joined(separator: ",")
        let queryItems = [URLQueryItem(name: "folderId", value: folderId as? String),
                          URLQueryItem(name: "words", value: wordsStr),
                          URLQueryItem(name: "targetLanguage", value: targetLang.code),
                          URLQueryItem(name: "sourceLanguage", value: sourceLang.code)]
        var urlComps = URLComponents(string: "https://functions.yandexcloud.net/d4edekrnjuqtc7cudnj4?")!
        urlComps.queryItems = queryItems
        let result = urlComps.url
        return result
    }
    
    func imageUrl(word: String, language: Language) -> URL?  {
        guard let clientId = Bundle.main.object(forInfoDictionaryKey: "CLIENT_ID") else { return nil }
        let queryItems = [URLQueryItem(name: C.clienID, value: clientId as? String),
                          URLQueryItem(name: "query", value: word),
                          URLQueryItem(name: "page", value: "1"),
                          URLQueryItem(name: "per_page", value: "1"),
                          URLQueryItem(name: "lang", value: language.code),
                          URLQueryItem(name: "content_filter", value: "high"),
                          URLQueryItem(name: "orientation", value: "squarish")]
        var urlComps = URLComponents(string: "https://api.unsplash.com/search/photos?")!
        urlComps.queryItems = queryItems
        let result = urlComps.url
        return result
    }
}
