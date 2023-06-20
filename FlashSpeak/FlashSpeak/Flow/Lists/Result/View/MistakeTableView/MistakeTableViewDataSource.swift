//
//  MistakeTableViewDataSource.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 03.06.2023.
//
// swiftlint: disable line_length

import UIKit

class MistakeTableViewDataSource: NSObject, UITableViewDataSource {
    
    weak var view: MistakeTableViewProtocol?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return view?.mistakeViewModels.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: MistakeTableViewCell.identifier, for: indexPath) as? MistakeTableViewCell,
            let viewModel = view?.mistakeViewModels[indexPath.item]
        else { return UITableViewCell() }
        cell.configure(viewModel: viewModel)
        return cell
    }
}

// swiftlint: enable line_length
