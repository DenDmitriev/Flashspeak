//
//  StatisticsViewController.swift
//  Lingocard
//
//  Created by Denis Dmitriev on 12.04.2023.
//
// swiftlint:disable weak_delegate

import UIKit

class StatisticsViewController: UIViewController {
    
    // MARK: - Properties
    
    var statisticDayViewModels = [StatisticViewModel]()
    var statisticAllViewModels = [StatisticViewModel]()
    
    // MARK: - Private properties
    private let presenter: StatisticViewOutput
    private let collectionViewDataSource: UICollectionViewDataSource
    private let collectionViewDelegate: UICollectionViewDelegate
    
    // MARK: - Constraction
    
    private var statisticsView: StatisticsView {
        return self.view as? StatisticsView ?? StatisticsView()
    }
    
    init(
        presenter: StatisticViewOutput,
        collectionViewDataSource: UICollectionViewDataSource,
        collectionViewDelegate: UICollectionViewDelegate
    ) {
        self.presenter = presenter
        self.collectionViewDataSource = collectionViewDataSource
        self.collectionViewDelegate = collectionViewDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = StatisticsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        presenter.subscribe()
    }
    
    // MARK: - Private functions
    
    private func configureCollectionView() {
        statisticsView.collectionView.delegate = collectionViewDelegate
        statisticsView.collectionView.dataSource = collectionViewDataSource
    }

}

extension StatisticsViewController: StatisticViewInput {
    func updateViewModels(viewModels: [StatisticViewModel]) {
        let dayStatisticViewModel = viewModels.filter { $0.section == .today }
        let allStatisticViewModel = viewModels.filter { $0.section == .all }
        
        statisticDayViewModels = dayStatisticViewModel
        statisticAllViewModels = allStatisticViewModel
        
        self.statisticsView.collectionView.reloadData()
    }
}

// swiftlint:enable weak_delegate
