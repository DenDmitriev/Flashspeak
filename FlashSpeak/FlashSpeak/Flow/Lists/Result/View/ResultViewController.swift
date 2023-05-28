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
    
    // MARK: - Constraction
    
    init(
        presenter: ResultViewOutput
    ) {
        self.presenter = presenter
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
        presenter.subscribe()
        addTargets()
    }
    
    // MARK: - Private functions
    
    private func addTargets() {
        resultView.repeatButton.addTarget(
            self,
            action: #selector(repeatDidTap(sender:)),
            for: .touchUpInside
        )
    }
    
    // MARK: - Actions

    @objc func repeatDidTap(sender: UIButton) {
        repeatDidTap()
    }
}

// MARK: - Functions

extension ResultViewController: ResultViewInput {
    
    func repeatDidTap() {
        presenter.repeatDidTap()
    }
    
    func updateResults(viewModels: [ResultViewModel]) {
        resultView.updateResultCollectionView(viewModels: viewModels)
    }
    
    func updateMistakes(viewModels: [WordCellModel]) {
        resultView.updateMistakeCollectionView(viewModels: viewModels)
    }
}

// swiftlint:enable weak_delegate
