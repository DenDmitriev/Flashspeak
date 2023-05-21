//
//  MainTabBar.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import UIKit

enum TabBarPage {
    case lists
    case statistic

    init?(index: Int) {
        switch index {
        case 0:
            self = .lists
        case 1:
            self = .statistic
        default:
            return nil
        }
    }
    
    func pageTitle() -> String {
        switch self {
        case .lists:
            return NSLocalizedString("Word Lists", comment: "Title")
        case .statistic:
            return NSLocalizedString("Statistics", comment: "Title")
        }
    }

    func pageOrderNumber() -> Int {
        switch self {
        case .lists:
            return 0
        case .statistic:
            return 1
        }
    }
    
    func tabIcon() -> UIImage {
        switch self {
        case .lists:
            return UIImage(systemName: "square.stack.fill") ?? UIImage()
        case .statistic:
            return UIImage(systemName: "chart.bar.xaxis") ?? UIImage()
        }
    }
}
