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
    
    var resultViewModels = [ResultViewModel]()
    
    // MARK: - Private properties
    private var presenter: ResultViewOutput
    private let gestureRecognizerDelegate: UIGestureRecognizerDelegate
    private let resultCollectionViewDataSource: UICollectionViewDataSource
    private let resultCollectionViewDelegate: UICollectionViewDelegate
    
    // MARK: - Constraction
    
    init(
        presenter: ResultViewOutput,
        gestureRecognizerDelegate: UIGestureRecognizerDelegate,
        resultCollectionViewDataSource: UICollectionViewDataSource,
        resultCollectionViewDelegate: UICollectionViewDelegate
    ) {
        self.presenter = presenter
        self.gestureRecognizerDelegate = gestureRecognizerDelegate
        self.resultCollectionViewDataSource = resultCollectionViewDataSource
        self.resultCollectionViewDelegate = resultCollectionViewDelegate
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
        configureCollectionView()
        presenter.subscribe()
    }
    
    // MARK: - Private functions
    
    private func configureCollectionView() {
        resultView.resultsCollectionView.delegate = resultCollectionViewDelegate
        resultView.resultsCollectionView.dataSource = resultCollectionViewDataSource
    }
    
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
    
    func updateResults() {
        resultView.updateResultCollectionView()
    }
}

// swiftlint:enable weak_delegate
