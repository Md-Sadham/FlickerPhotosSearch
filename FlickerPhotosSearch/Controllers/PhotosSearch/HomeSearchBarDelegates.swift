//
//  HomeSearchBarDelegates.swift
//  FlickerPhotosSearch
//
//  Created by D MacBook Pro on 16/08/2021.
//

import UIKit

extension HomeViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.flickerSearch(searchBar.text)
        view.endEditing(true)
    }

    func flickerSearch(_ searchText: String?) {
        guard let strText = searchText else {return}
        if !strText.isEmpty {
            let searchText: String =  searchText!.replacingOccurrences(of: " ", with: "")
            
            // Call View Model. Call Flicker API.
            self.setupViewModel(searchText: searchText)
        }
    }
}
