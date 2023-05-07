//
//  StatisticsViewController.swift
//  Lingocard
//
//  Created by Denis Dmitriev on 12.04.2023.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Private properties
    
    // MARK: - Constraction
    
    private var statisticsView: StatisticsView {
        return self.view as? StatisticsView ?? StatisticsView()
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = StatisticsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
