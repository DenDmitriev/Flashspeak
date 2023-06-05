//
//  HintController.swift
//  FlashSpeak
//
//  Created by Оксана Каменчук on 22.05.2023.
//
// swiftlint: disable line_length

import UIKit

class HintController: UIViewController {
    
    // MARK: - Properties
    
    var hints = [
        NSLocalizedString("To add a word use the enter key, a comma after the word, or the + button, which is located to the right of the input field.", comment: "Title"),
        NSLocalizedString("To delete or correct an already entered word, click on it and hold for a couple of seconds, the delete field and the edit field are activated. Drag the word to the desired field.", comment: "Title")
    ]
    weak var gestureRecognizerDelegate: UIGestureRecognizerDelegate?
    
    // MARK: - Private properties
    
    private var presenter: HintViewOutput
    
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
        return self.view as? HintView ?? HintView(hints: hints, delegate: self)
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = HintView(hints: hints, delegate: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addAction()
        configureGesture()
        
    }

    // MARK: - Private functions
    
    private func addAction() {
        hintView.furtherButton.addTarget(
            self,
            action: #selector(didTapFurther(sender:)),
            for: .touchUpInside
        )
    }

    private func configureGesture() {
        let tapBackground = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapBackroundView(sender:))
        )
        tapBackground.delegate = gestureRecognizerDelegate
        self.hintView.addGestureRecognizer(tapBackground)
    }
    
    private func isLastPage(_ index: Int) -> Bool {
        return index == hints.index(before: hints.endIndex)
    }
    
    // MARK: - Actions
    
    @objc private func didTapBackroundView(sender: UIView) {
        didTabBackground()
    }
    
    @objc private func didTapFurther(sender: UIButton) {
        let isLastPage = isLastPage(hintView.pageControl.currentPage)
        if isLastPage {
            dismiss(animated: true)
        } else {
            hintView.scrollToNextPage()
        }
    }
}

extension HintController: HintViewInput {
    
    // MARK: - Functions
   
    func didTabBackground() {
        presenter.viewDidTapBackground()
    }
}

extension HintController: HintViewDelegate {
    
    func pageDidChange(_ index: Int) {
        let isLastPage = isLastPage(index)
        let title = isLastPage ? NSLocalizedString("Reset", comment: "Button") : NSLocalizedString("Further", comment: "Button")
        hintView.furtherButton.configurationUpdateHandler = { button in
            button.configuration?.title = title
        }
    }
}

// swiftlint: enable line_length
