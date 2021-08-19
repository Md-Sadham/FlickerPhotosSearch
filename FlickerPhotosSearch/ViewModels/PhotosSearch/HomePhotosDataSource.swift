//
//  HomePhotosDataSource.swift
//  FlickerPhotosSearch
//
//  Created by D MacBook Pro on 13/08/2021.
//

import Foundation
import UIKit

class HomePhotosDataSource<Cell: HomePhotosCell, T>: NSObject, UICollectionViewDataSource {
    
    private var items: [T]!
    var configureCell : (Cell, T) -> () = {_,_ in }
    
    private var selectedPhotoModel : PhotoModel?
    
    init(items: [T], configureCell: @escaping (Cell, T) -> ()) {
        self.items = items
        self.configureCell = configureCell
    }
    
    init(items: [T], selectedPhotoModel: PhotoModel, configureCell: @escaping (Cell, T) -> ()) {
        self.items = items
        self.configureCell = configureCell
        self.selectedPhotoModel = selectedPhotoModel
    }
    
    // TODO: Its better if we show saved photos and Flicker photos in each section.
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.photosCellID, for: indexPath) as! Cell
        
        let item = self.items[indexPath.row]
        configureCell(cell, item)
        
        // highlight cell if any selected
        cell.removeHighlight()
        if let photoModel = item as? PhotoModel, let selectedModel = selectedPhotoModel {
            if photoModel.id == selectedModel.id {
                cell.highlightEffect()
            }
        }
        
        return cell
    }
}
