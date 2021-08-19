//
//  HomeSearchBarDelegates.swift
//  FlickerPhotosSearch
//
//  Created by D MacBook Pro on 16/08/2021.
//

import UIKit

extension HomeViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.flickerSearch(searchBar.text)
        view.endEditing(true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }

    func flickerSearch(_ searchText: String?) {
        guard let strText = searchText else {return}
        if !strText.isEmpty {
            let searchText: String =  searchText!.replacingOccurrences(of: " ", with: "")
            self.setupViewModel(searchText: searchText)
        }
    }
}
