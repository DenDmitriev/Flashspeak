//
//  ResultTableView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 03.06.2023.
//
// swiftlint:disable weak_delegate

import UIKit

protocol ResultTableViewProtocol: AnyObject {
    var resultViewModels: [ResultViewModel] { get set }
}

class ResultTableView: UITableView {
    
    var resultViewModels = [ResultViewModel]()
    
    private let resultTableViewDataSource: UITableViewDataSource
    private let resultTableViewDelegate: UITableViewDelegate

    override init(frame: CGRect, style: UITableView.Style) {
        let resultTableViewDataSource = ResultTableViewDataSource()
        let resultTableViewDelegate = ResultTableViewDelegate()
        self.resultTableViewDataSource = resultTableViewDataSource
        self.resultTableViewDelegate = resultTableViewDelegate
        super.init(frame: frame, style: style)
        resultTableViewDelegate.view = self
        resultTableViewDataSource.view = self
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        delegate = resultTableViewDelegate
        dataSource = resultTableViewDataSource
        register(ResultTableViewCell.self, forCellReuseIdentifier: ResultTableViewCell.identifier)
    }
    
}

extension ResultTableView: ResultTableViewProtocol {
    
}

// swiftlint:enable weak_delegate
