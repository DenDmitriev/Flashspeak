//
//  LearnSettingsViewController.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 07.05.2023.
//

import UIKit

class LearnSettingsViewController: UIViewController, ObservableObject {
    
    // MARK: - Properties
    var learnSettings: LearnSettings
    
    // MARK: - Private properties
    private var presenter: LearnSettingsViewOutput

    // MARK: - Constraction
    
    init(
        presenter: LearnSettingsViewOutput,
        learnSettings: LearnSettings
    ) {
        self.presenter = presenter
        self.learnSettings = learnSettings
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var learnSettingsView: LearnSettingsView {
        return self.view as? LearnSettingsView ?? LearnSettingsView(
            learnSettings: learnSettings,
            delegate: self
        )
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = LearnSettingsView(learnSettings: learnSettings, delegate: self)
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

extension LearnSettingsViewController: LearnSettingsViewDelegate {
    
    func settingsChanged(_ settings: LearnSettings) {
        presenter.settingsChanged(settings)
    }
}
