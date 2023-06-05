//
//  HintController.swift
//  FlashSpeak
//
//  Created by Оксана Каменчук on 22.05.2023.
//
// swiftlint: disable line_length

import UIKit

class HintController: UIViewController, HintViewDelegate {
    
    func getIndex(_ index: Int) {
        hintView.paragraphOneLabel.text = hints[index]
    }
    
    // MARK: - Properties
    
    
    // MARK: - Private properties
    
    private var presenter: HintViewOutput
    weak var gestureRecognizerDelegate: UIGestureRecognizerDelegate?
    
    var hints = [NSLocalizedString("To add a word use the enter key, a comma after the word, or the + button, which is located to the right of the input field.", comment: "Title"), NSLocalizedString("To delete or correct an already entered word, click on it and hold for a couple of seconds, the delete field and the edit field are activated. Drag the word to the desired field.", comment: "Title")]
    
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
        hintView.delegate = self
        hintView.hints = self.hints
        hintView.paragraphOneLabel.text = hints[0]
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
    
    private func updateView(at page: Int) {
        let isLastPage = hintView.pageControl.currentPage == hints.endIndex - 1
        let title = isLastPage ? NSLocalizedString("Further", comment: "Button") : NSLocalizedString("Reset", comment: "Button")
        hintView.furtherButton.setTitle(title, for: .normal)
        getIndex(page)
        hintView.pageControl.currentPage = page
    }

    private func scrollToNextPage() {
        let currentPage = hintView.pageControl.currentPage
        guard currentPage != hintView.hints.endIndex - 1 else {
            return
        }

        UIView.animate(withDuration: 0.3) { [self] in
            let page = currentPage + 1
            updateView(at: page)
        }
    }

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
    
    @objc private func didTapFurther(sender: UIButton) {
        let isLastPage = hintView.pageControl.currentPage == hints.endIndex - 1
        if isLastPage {
            dismiss(animated: true)
        } else {
            scrollToNextPage()
        }
    }
}

extension HintController: HintViewInput {
    
    // MARK: - Functions
   
    func didTabBackground() {
        presenter.viewDidTapBackground()
    }
}

// swiftlint: enable line_length
