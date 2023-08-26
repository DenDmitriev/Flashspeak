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
    
    func translateURLGoogle(words: [String], targetLang: Language, sourceLang: Language) -> URL? {
        guard
            let key = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_API_KEY"),
            let str = key as? String
        else { return nil }
        var queryItems = [
            URLQueryItem(name: "key", value: str),
            URLQueryItem(name: "target", value: targetLang.code),
            URLQueryItem(name: "source", value: sourceLang.code),
            URLQueryItem(name: "format", value: "text")
        ]
        words.forEach { word in
            queryItems.append(URLQueryItem(name: "q", value: word))
        }
        var components = URLComponents()
        components.scheme = "https"
        components.host = "translation.googleapis.com"
        components.path = "/language/translate/v2"
        components.queryItems = queryItems
        let url = components.url
        return url
    }
    
    func imageURL(word: String, language: Language, count: Int = 1) -> URL? {
        guard
            let clientId = Bundle.main.object(forInfoDictionaryKey: "CLIENT_ID"),
            let str = clientId as? String
        else { return nil }
        let queryItems = [
            URLQueryItem(name: Constants.clienID, value: str),
            URLQueryItem(name: "query", value: word),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "per_page", value: String(count)),
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
