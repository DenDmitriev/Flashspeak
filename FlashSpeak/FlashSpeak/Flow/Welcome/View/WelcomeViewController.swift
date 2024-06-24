//
//  WelcomeViewController.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 28.04.2023.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    let presenter: WelcomeViewOutput
    
    // MARK: - Constraction
    
    init(presenter: WelcomeViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var welcomeView: WelcomeView {
        return view as? WelcomeView ?? WelcomeView()
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        view = WelcomeView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.subscribe()
        configureButtonActions()
    }
    
    // MARK: - Private functions
    
    private func configureButtonActions() {
        welcomeView.eventButton.addTarget(
            self,
            action: #selector(didTabEventButton(sender:)),
            for: .touchUpInside
        )
        
        welcomeView.sourcelanguageButton.addTarget(
            self,
            action: #selector(didTabSourceButton(sender:)),
            for: .touchUpInside
        )
        
        welcomeView.targetlanguageButton.addTarget(
            self,
            action: #selector(didTabTargetButton(sender:)),
            for: .touchUpInside
        )
    }
    
    // MARK: - Actions
    
    @objc func didTabEventButton(sender: UIButton) {
        didTabDoneButton()
    }
    
    @objc func didTabSourceButton(sender: UIButton) {
        didTabSourceButton()
    }
    
    @objc func didTabTargetButton(sender: UIButton) {
        didTabTargetButton()
    }
}

extension WelcomeViewController: WelcomeViewInput {
    
    func configureButtons(type: Language.LanguageType, language: Language) {
        welcomeView.configureButtons(type: type, language: language)
    }
    
    func didTabDoneButton() {
        presenter.next()
    }
    
    func didTabSourceButton() {
        presenter.selectSourceLanguage()
    }
    
    func didTabTargetButton() {
        presenter.selectTargetLanguage()
    }
    
    func button(isEnable: Bool) {
        welcomeView.eventButton.isEnabled = isEnable
    }
}

@available(iOS 17, *)
#Preview {
    WelcomeBuilder.build(router: WelcomeRouter())
}
