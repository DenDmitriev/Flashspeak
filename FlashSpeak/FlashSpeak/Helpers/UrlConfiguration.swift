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
        guard let folderId = Bundle.main.infoDictionary?["FOLDER_ID"] as? String else { return nil }
        let wordsStr = words.joined(separator: ",")
        let queryItems = [URLQueryItem(name: "folderId", value: folderId),
                          URLQueryItem(name: "words", value: wordsStr),
                          URLQueryItem(name: "targetLanguage", value: targetLang.code),
                          URLQueryItem(name: "sourceLanguage", value: sourceLang.code)]
        var urlComps = URLComponents(string: "https://functions.yandexcloud.net/d4edekrnjuqtc7cudnj4?")!
        urlComps.queryItems = queryItems
        let result = urlComps.url
        return result
    }
    
    func imageUrl(word: String) -> URL?  {
        guard let clientId = Bundle.main.infoDictionary?["CLIENT_ID"] as? String else { return nil }
        let queryItems = [URLQueryItem(name: "client_id", value: clientId),
                          URLQueryItem(name: "query", value: word),
                          URLQueryItem(name: "page", value: "1"),
                          URLQueryItem(name: "per_page", value: "1"),
                          URLQueryItem(name: "lang", value: "en"),
                          URLQueryItem(name: "content_filter", value: "high"),
                          URLQueryItem(name: "orientation", value: "squarish")]
        var urlComps = URLComponents(string: "https://api.unsplash.com/search/photos?")!
        urlComps.queryItems = queryItems
        let result = urlComps.url
        return result
    }
}
