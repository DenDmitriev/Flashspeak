//
//  ResultViewController.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 07.05.2023.
//

import UIKit
import SwiftUI

class ResultViewController: UIViewController {
    
    // MARK: - Properties
    var style: GradientStyle?
    
    // MARK: - Private properties
    private var presenter: ResultViewOutput
    
    // MARK: - Constraction
    
    init(
        presenter: ResultViewOutput
    ) {
        self.presenter = presenter
        self.style = presenter.list.style
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var resultView: ResultView {
        return self.view as? ResultView ?? ResultView(color: style?.color)
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = ResultView(color: style?.color)
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
        
        resultView.settingsButton.addTarget(
            self,
            action: #selector(didTapSettings(sender:)),
            for: .touchUpInside
        )
    }
    
    // MARK: - Actions

    @objc func repeatDidTap(sender: UIButton) {
        repeatDidTap()
    }
    
    @objc private func didTapSettings(sender: UIButton) {
        settingsDidTap()
    }
}

// MARK: - Functions

extension ResultViewController: ResultViewInput {
    
    func repeatDidTap() {
        presenter.repeatDidTap()
    }
    
    func settingsDidTap() {
        presenter.settingsDidTap()
    }
    
    func updateResults(
        resultViewModels: [ResultViewModel],
        chartViewModels: [[ChartLearnViewModel]],
        color: UIColor
    ) {
        resultView.updateResults(viewModels: resultViewModels)
        
        if chartViewModels.isEmpty {
            resultView.chartStackView.isHidden = true
        } else {
            chartViewModels.forEach { viewModels in
                let viewController = UIHostingController(
                    rootView: ChartLearnView(viewModels: viewModels, color: Color(color))
                )
                let chartView = viewController.view ?? UIView()
                resultView.updateChartView(chartView)
                addChild(viewController)
                viewController.didMove(toParent: self)
                resultView.chartStackView.isHidden = false
            }
        }
    }
    
    func updateMistakes(viewModels: [WordCellModel]) {
        resultView.updateMistakes(viewModels: viewModels)
    }
}
