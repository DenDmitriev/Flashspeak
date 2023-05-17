//
//  MainTabBar.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import UIKit

enum TabBarPage {
    case lists
    case study
    case statistic

    init?(index: Int) {
        switch index {
        case 0:
            self = .lists
        case 1:
            self = .study
        case 2:
            self = .statistic
        default:
            return nil
        }
    }
    
    func pageTitle() -> String {
        switch self {
        case .lists:
            return NSLocalizedString("Списки слов", comment: "Title")
        case .study:
            return NSLocalizedString("Изучение", comment: "Title")
        case .statistic:
            return NSLocalizedString("Статистика", comment: "Title")
        }
    }

    func pageOrderNumber() -> Int {
        switch self {
        case .lists:
            return 0
        case .study:
            return 1
        case .statistic:
            return 2
        }
    }
    
    func tabIcon() -> UIImage {
        switch self {
        case .lists:
            return UIImage(systemName: "square.stack.fill") ?? UIImage()
        case .study:
            return UIImage(systemName: "play.square.stack.fill") ?? UIImage()
        case .statistic:
            return UIImage(systemName: "chart.bar.xaxis") ?? UIImage()
        }
    }
}
