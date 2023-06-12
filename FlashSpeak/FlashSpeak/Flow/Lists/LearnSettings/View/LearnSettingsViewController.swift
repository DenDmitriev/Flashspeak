//
//  LearnSettingsViewController.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 07.05.2023.
//

import UIKit

class LearnSettingsViewController: UIViewController, ObservableObject {
    
    // MARK: - Properties
    var learnSettingsManager: LearnSettingsManager
    
    // MARK: - Private properties
    private var presenter: LearnSettingsViewOutput

    // MARK: - Constraction
    
    init(
        presenter: LearnSettingsViewOutput,
        settingsManager: LearnSettingsManager
    ) {
        self.presenter = presenter
        self.learnSettingsManager = settingsManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var learnSettingsView: LearnSettingsView {
        return self.view as? LearnSettingsView ?? LearnSettingsView(
            settingsManager: learnSettingsManager
        )
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = LearnSettingsView(
            settingsManager: learnSettingsManager
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        presenter.configureView()
    }
    
    // MARK: - Private functions
    
    // MARK: - Actions
}

// MARK: - Functions

extension LearnSettingsViewController: LearnSettingsViewInput {
}
