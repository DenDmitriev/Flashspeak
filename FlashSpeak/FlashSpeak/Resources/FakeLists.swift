//
//  FakeLists.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import Foundation

struct FakeLists {
    static let lists = [
        List(
            title: "Человек",
            words: [
                Word(source: "люди", translation: "people"),
                Word(source: "семья", translation: "family"),
                Word(source: "женщина", translation: "women"),
                Word(source: "мужчина", translation: "man"),
                Word(source: "девочка", translation: "girl"),
                Word(source: "мальчик", translation: "boy"),
                Word(source: "ребёнок", translation: "baby"),
                Word(source: "друг", translation: "friend"),
                Word(source: "муж", translation: "husband"),
                Word(source: "жена", translation: "wife"),
                Word(source: "имя", translation: "name"),
                Word(source: "голова", translation: "head"),
                Word(source: "лицо", translation: "face")
            ],
            style: .red,
            created: Date.now,
            addImageFlag: true),
        List(
            title: "Время",
            words: [
                Word(source: "жизнь", translation: "life"),
                Word(source: "час", translation: "hour"),
                Word(source: "неделя", translation: "week"),
                Word(source: "день", translation: "day"),
                Word(source: "ночь", translation: "night"),
                Word(source: "месяц", translation: "month"),
                Word(source: "год", translation: "year"),
                Word(source: "время", translation: "time")
            ],
            style: .green,
            created: Date.now,
            addImageFlag: true),
        List(
            title: "Природа",
            words: [
                Word(source: "мир", translation: "world"),
                Word(source: "солнце", translation: "sun"),
                Word(source: "животное", translation: "animal"),
                Word(source: "дерево", translation: "tree"),
                Word(source: "вода", translation: "woter"),
                Word(source: "еда", translation: "food"),
                Word(source: "огонь", translation: "fier")
            ],
            style: .yellow,
            created: Date.now,
            addImageFlag: true)
    ]
}
