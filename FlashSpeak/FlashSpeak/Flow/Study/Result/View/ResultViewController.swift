//
//  ResultViewController.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 07.05.2023.
//
// swiftlint:disable weak_delegate

import UIKit

class ResultViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Private properties
    private var presenter: ResultViewOutput
    private let gestureRecognizerDelegate: UIGestureRecognizerDelegate
    
    // MARK: - Constraction
    
    init(presenter: ResultViewOutput, gestureRecognizerDelegate: UIGestureRecognizerDelegate) {
        self.presenter = presenter
        self.gestureRecognizerDelegate = gestureRecognizerDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var resultView: ResultView {
        return self.view as? ResultView ?? ResultView()
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = ResultView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureGesture()
    }
    
    // MARK: - Private functions
    
    private func configureGesture() {
        let tapBackground = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapBackroundView(sender:))
        )
        tapBackground.delegate = gestureRecognizerDelegate
        self.resultView.addGestureRecognizer(tapBackground)
    }
    
    // MARK: - Actions

    @objc private func didTapBackroundView(sender: UIView) {
        didTabBackground()
    }

}

// MARK: - Functions

extension ResultViewController: ResultViewInput {
    
    func didTabBackground() {
        presenter.viewDidTapBackground()
    }
}

// swiftlint:enable weak_delegate
