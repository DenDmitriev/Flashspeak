//
//  AddNewWordViewController.swift
//  FlashSpeak
//
//  Created by Anastasia Losikova on 28.05.2023.
//

import UIKit

class AddNewWordViewController: UIViewController {
    
    // MARK: Private properties
    
    private let presenter: AddNewWordOutput
    private var mainView: AddNewWordView {
        return view as? AddNewWordView ?? AddNewWordView(style: .grey)
    }
    private let style: GradientStyle
    
    private var addNewWordView: AddNewWordView {
        return self.view as? AddNewWordView ?? AddNewWordView(style: style)
    }
    
    // MARK: Init
    
    init(presenter: AddNewWordOutput, style: GradientStyle) {
        self.presenter = presenter
        self.style = style
        super.init(nibName: nil, bundle: nil)
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = AddNewWordView(style: style)
    }
    
    // MARK: Private properties
    
    private func configureButton() {
        mainView.button.addTarget(
            self,
            action: #selector(saveTapped),
            for: .touchUpInside
        )
    }
    
    @objc private func saveTapped() {
        guard let text = mainView.getText() else { return }
        presenter.saveWord(text: text)
    }
}

// MARK: - Input Ext

extension AddNewWordViewController: AddNewWordInput {
    func showAlert(with text: String) {
        let alert = UIAlertController(
            title: NSLocalizedString("Error", comment: "Title"),
            message: text,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: NSLocalizedString("Ok", comment: "Title"),
            style: .default
        )
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    func spinner(isActive: Bool, text: String?) {
        addNewWordView.button.configurationUpdateHandler = { button in
            var config = button.configuration
            config?.showsActivityIndicator = isActive
            config?.title = text
            button.isEnabled = !isActive
            button.configuration = config
        }
    }
}
