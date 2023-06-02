//
//  HintController.swift
//  FlashSpeak
//
//  Created by Оксана Каменчук on 22.05.2023.
//

import UIKit

class HintController: UIViewController {
    
    // MARK: - Properties
    
    
    // MARK: - Private properties
    
    private var presenter: HintViewOutput
    private let gestureRecognizerDelegate: UIGestureRecognizerDelegate
    
    // MARK: - Constraction
    
    init(
        presenter: HintPresenter,
        gestureRecognizerDelegate: UIGestureRecognizerDelegate
    ) {
        self.presenter = presenter
        self.gestureRecognizerDelegate = gestureRecognizerDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var hintView: HintView {
        return self.view as? HintView ?? HintView()
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = HintView()
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
        self.hintView.addGestureRecognizer(tapBackground)
    }
    
    // MARK: - Actions
    
    @objc private func didTapBackroundView(sender: UIView) {
        didTabBackground()
    }
}

extension HintController: HintViewInput {
    
    // MARK: - Functions
    
    func setTitle(_ title: String?, description: String?) {
        hintView.setTitle(title, description: description)
    }
    
    func didTabBackground() {
        presenter.viewDidTapBackground()
    }
}
