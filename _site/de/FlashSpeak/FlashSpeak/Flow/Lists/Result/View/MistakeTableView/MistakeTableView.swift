//
//  MistakeTableView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 03.06.2023.
//
// swiftlint: disable weak_delegate

import UIKit

protocol MistakeTableViewProtocol: AnyObject {
    var mistakeViewModels: [WordCellModel] { get set }
}

class MistakeTableView: UITableView {
    
    var mistakeViewModels = [WordCellModel]()
    
    private let mistakeTableViewDataSource: UITableViewDataSource
    private let mistakeTableViewDelegate: UITableViewDelegate

    override init(frame: CGRect, style: UITableView.Style) {
        let mistakeTableViewDataSource = MistakeTableViewDataSource()
        let mistakeTableViewViewDelegate = MistakeTableViewDelegate()
        self.mistakeTableViewDataSource = mistakeTableViewDataSource
        self.mistakeTableViewDelegate = mistakeTableViewViewDelegate
        super.init(frame: frame, style: .plain)
        mistakeTableViewDataSource.view = self
        mistakeTableViewViewDelegate.view = self
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        delegate = mistakeTableViewDelegate
        dataSource = mistakeTableViewDataSource
        register(MistakeTableViewCell.self, forCellReuseIdentifier: MistakeTableViewCell.identifier)
    }
}

extension MistakeTableView: MistakeTableViewProtocol {
    
}

// swiftlint: enable weak_delegate
