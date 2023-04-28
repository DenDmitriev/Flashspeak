//
//  Coordinator.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 20.04.2023.
//

import UIKit

// MARK: - Coordinator
protocol Coordinator: AnyObject {
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    // Каждому координатору назначен один навигационный контроллер
    var navigationController: UINavigationController { get set }
    /// Массив для  всех дочерних координаторов
    var childCoordinators: [Coordinator] { get set }
    /// Определенный тип потока
    var type: CoordinatorType { get }
    /// Место, где можно поставить логику, чтобы начать поток
    func start()
    /// Место, где можно поставить логику, чтобы закончить поток,
    /// очистить всех дочерних координаторов и уведомить родителя о том,
    /// что этот координатор готов к завершению
    func finish()
    
    init(_ navigationController: UINavigationController)
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

// MARK: - CoordinatorOutput
/// Протокол делегата, помогающий родительскому координатору узнать, когда его дочерний готов к завершению
protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}

// MARK: - CoordinatorType
/// Используя эту структуру, мы можем определить, какой тип потока мы можем использовать в приложении
enum CoordinatorType {
    case app, tab, welcome, lists
}
