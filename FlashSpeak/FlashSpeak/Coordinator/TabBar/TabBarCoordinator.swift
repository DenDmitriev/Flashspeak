//
//  MainTabBarCoordinator.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import UIKit

protocol TabBarCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get set }
    
    func selectPage(_ page: TabBarPage)
    
    func setSelectedIndex(_ index: Int)
    
    func currentPage() -> TabBarPage?
}

class TabBarCoordinator: NSObject, Coordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
        
    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController
    
    var tabBarController: UITabBarController

    var type: CoordinatorType { .tab }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = .init()
        super.init()
    }

    func start() {
        let pages: [TabBarPage] = [.lists, .study, .statistic]
            .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
        
        let controllers: [UINavigationController] = pages.map({ getTabController($0) })
        
        prepareTabBarController(withTabControllers: controllers)
    }
    
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {

        tabBarController.delegate = self
        /// Назначение  контроллеров страницы
        tabBarController.setViewControllers(tabControllers, animated: true)
        /// Установка индекса
        tabBarController.selectedIndex = TabBarPage.lists.pageOrderNumber()
        /// Стилизация
        tabBarController.tabBar.isTranslucent = false
        tabBarController.view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBarController.tabBar.tintColor = .tint
        setupAppearance()
        
        /// Прикрепляем tabBarController к навигационному контроллеру, связанному с этим координатором.
        navigationController.viewControllers = [tabBarController]
    }
      
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.tabBarItem = UITabBarItem.init(title: page.pageTitle(), image: page.tabIcon(), tag: page.pageOrderNumber())
        navigationController.navigationBar.prefersLargeTitles = true

        switch page {
        case .lists:
            let listsCoordinator = ListsCoordinator(navigationController)
            listsCoordinator.finishDelegate = self
            listsCoordinator.start()
            childCoordinators.append(listsCoordinator)
        case .study:
            let studyViewController = StudyViewController()
            studyViewController.navigationItem.title = page.pageTitle()
            navigationController.pushViewController(studyViewController, animated: true)
        case .statistic:
            let statisticsViewController = StatisticsViewController()
            statisticsViewController.navigationItem.title = page.pageTitle()
            navigationController.pushViewController(statisticsViewController, animated: true)
        }
        
        return navigationController
    }
    
    func currentPage() -> TabBarPage? { TabBarPage.init(index: tabBarController.selectedIndex) }

    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage.init(index: index) else { return }
        
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    private func setupAppearance() {
        let positionOnX: CGFloat = 0
        let positionOnY: CGFloat = 16
        let width = tabBarController.tabBar.bounds.width - positionOnX * 2
        let height = tabBarController.tabBar.bounds.height + positionOnY * 2
        let roundlayer = CAShapeLayer()
        
        let bezierPath = UIBezierPath(
            roundedRect: CGRect(
                x: positionOnX,
                y: tabBarController.tabBar.bounds.minY - positionOnY,
                width: width,
                height: height + positionOnY
            ),
            cornerRadius: positionOnY
        )
        
        roundlayer.path = bezierPath.cgPath
        
        tabBarController.tabBar.layer.insertSublayer(roundlayer, at: 0)
        tabBarController.tabBar.itemPositioning = .centered
        
        roundlayer.fillColor = UIColor.backgroundLightGray.cgColor
        tabBarController.tabBar.tintColor = .tint
        tabBarController.tabBar.unselectedItemTintColor = .tabBarUnselected
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // Some implementation
    }
}

extension TabBarCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        childCoordinator.navigationController.dismiss(animated: false)
        
        switch childCoordinator.type {
        case .lists:
            reloadTabBarPage(page: .lists)
        default:
            break
        }
    }
    
    private func reloadTabBarPage(page: TabBarPage) {
        let newNavigationController = getTabController(page)
        tabBarController.viewControllers?[page.pageOrderNumber()] = newNavigationController
    }
    
}
