//
//  ListSearchResultsController.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 15.06.2023.
//

import UIKit

class ListSearchResultsController: NSObject, UISearchResultsUpdating {
    
    weak var viewController: (UIViewController & ListsViewInput)?
    
    func updateSearchResults(for searchController: UISearchController) {
        guard
            let searchText = searchController.searchBar.text?.lowercased()
        else { return }
        let isSearching = !searchText.isEmpty
        viewController?.isSearching = isSearching
        if isSearching {
            viewController?.serachListCellModels.removeAll()
            let viewModels = viewController?.listCellModels
                .filter({
                    $0.title.contains(searchText) ||
                    $0.words.joined(separator: " ").contains(searchText) 
                }) ?? []
            viewController?.serachListCellModels = viewModels
        } else {
            viewController?.serachListCellModels.removeAll()
            let viewModels = viewController?.listCellModels ?? []
            viewController?.serachListCellModels = viewModels
        }
        viewController?.reloadListsView()
    }
}

extension ListSearchResultsController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewController?.isSearching = false
        viewController?.serachListCellModels.removeAll()
        let viewModels = viewController?.listCellModels
        viewController?.serachListCellModels = viewModels ?? []
        viewController?.reloadListsView()
    }
}
