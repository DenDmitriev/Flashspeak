//
//  ResultTableViewDataSource.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 03.06.2023.
//
// swiftlint: disable line_length

import UIKit

class ResultTableViewDataSource: NSObject, UITableViewDataSource {
    
    weak var view: ResultTableView?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        view?.resultViewModels.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.identifier, for: indexPath) as? ResultTableViewCell,
            let viewModel = view?.resultViewModels[indexPath.item]
        else { return UITableViewCell() }
        cell.configure(viewModel: viewModel)
        return cell
    }
}

// swiftlint: enable line_length
