//
//  WordCardsSearchBarDelegate.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 14.06.2023.
//

import UIKit

class WordCardsSearchBarDelegate: NSObject, UISearchBarDelegate {
    weak var viewController: (UIViewController & WordCardsViewInput)?
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewController?.isSearching = false
        viewController?.searchingWordCardCellModels.removeAll()
        let viewModels = viewController?.wordCardCellModels ?? []
        viewController?.searchingWordCardCellModels = viewModels
        viewController?.reloadWordCardsCollection()
    }
    
}

extension WordCardsSearchBarDelegate: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard
            let searchText = searchController.searchBar.text?.lowercased()
        else { return }
        let isSearching = !searchText.isEmpty
        viewController?.isSearching = isSearching
        if isSearching {
            viewController?.searchingWordCardCellModels.removeAll()
            let filteredViewModels = viewController?.wordCardCellModels
                .filter({
                    $0.source.contains(searchText) ||
                    $0.translation.contains(searchText)
                }) ?? []
            viewController?.searchingWordCardCellModels = filteredViewModels
        } else {
            viewController?.searchingWordCardCellModels.removeAll()
            let viewModels = viewController?.wordCardCellModels ?? []
            viewController?.searchingWordCardCellModels = viewModels
        }
        viewController?.reloadWordCardsCollection()
    }
}
