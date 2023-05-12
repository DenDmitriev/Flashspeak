//
//  UrlConfiguration.swift
//  FlashSpeak
//
//  Created by Алексей Ходаков on 14.04.2023.
//

import Foundation

class URLConfiguration {
    
    // MARK: - Properties
    static let shared = URLConfiguration()
    
    // MARK: - Public functions
    func translateURL(words: [String], targetLang: Language, sourceLang: Language) -> URL? {
        guard let folderId = Bundle.main.object(forInfoDictionaryKey: "FOLDER_ID") else { return nil }
        guard let str = folderId as? String else { return nil }
        let wordsStr = words.joined(separator: ",")
        let queryItems = [
            URLQueryItem(name: "folderId", value: str),
            URLQueryItem(name: "words", value: wordsStr),
            URLQueryItem(name: "targetLanguage", value: targetLang.code),
            URLQueryItem(name: "sourceLanguage", value: sourceLang.code)
            ]
        guard var urlComps = URLComponents(
            string: "https://functions.yandexcloud.net/d4edekrnjuqtc7cudnj4?"
        ) else { return nil }
        urlComps.queryItems = queryItems
        let result = urlComps.url
        return result
    }
    
    func imageURL(word: String, language: Language) -> URL? {
        guard
            let clientId = Bundle.main.object(forInfoDictionaryKey: "CLIENT_ID")
        else { return nil }
        guard
            let str = clientId as? String
        else { return nil }
        print(#function, clientId)
        let queryItems = [
            URLQueryItem(name: Constants.clienID, value: str),
            URLQueryItem(name: "query", value: word),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "per_page", value: "1"),
            URLQueryItem(name: "lang", value: language.code),
            URLQueryItem(name: "content_filter", value: "high"),
            URLQueryItem(name: "orientation", value: "squarish")
        ]
        guard
            var urlComps = URLComponents(
            string: "https://api.unsplash.com/search/photos?"
        ) else { return nil }
        urlComps.queryItems = queryItems
        let result = urlComps.url
        return result
    }
}
