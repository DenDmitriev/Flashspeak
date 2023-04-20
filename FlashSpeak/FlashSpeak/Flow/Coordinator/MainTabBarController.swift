//
//  MainTabBarController.swift
//  Lingocard
//
//  Created by Denis Dmitriev on 12.04.2023.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupViewControllers()
        setupAppearance()
        tabBar.safeAreaInsetsDidChange()
    }
    
    func setupViewControllers() {
        viewControllers = [
            createNavigationController(
                for: ListsBuilder.build(),
                title: NSLocalizedString("Списки слов", comment: ""),
                image: UIImage(systemName: "square.stack.fill")),
            createNavigationController(
                for: StudyViewController(),
                title: NSLocalizedString("Изучение", comment: ""),
                image: UIImage(systemName: "play.square.stack.fill")),
            createNavigationController(
                for: StatisticsViewController(),
                title: NSLocalizedString("Статистика", comment: ""),
                image: UIImage(systemName: "chart.bar.xaxis"))
        ]
    }
    
    private func createNavigationController(for rootViewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        navigationController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navigationController
    }
    
    private func setupAppearance() {
        let positionOnX: CGFloat = 0
        let positionOnY: CGFloat = 16
        let width = tabBar.bounds.width - positionOnX * 2
        let height = tabBar.bounds.height + positionOnY * 2
        let roundlayer = CAShapeLayer()
        
        let bezierPath = UIBezierPath(
            roundedRect: CGRect(
                x: positionOnX,
                y: tabBar.bounds.minY - positionOnY,
                width: width,
                height: height + positionOnY
            ),
            cornerRadius: positionOnY
        )
        
        roundlayer.path = bezierPath.cgPath
        
        tabBar.layer.insertSublayer(roundlayer, at: 0)
        tabBar.itemPositioning = .centered
        
        roundlayer.fillColor = UIColor.backgroundLightGray.cgColor
        tabBar.tintColor = .tint
        tabBar.unselectedItemTintColor = .tabBarUnselected
    }

}
