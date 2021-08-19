//
//  HomePhotosViewModel.swift
//  FlickerPhotosSearch
//
//  Created by D MacBook Pro on 13/08/2021.
//

import Foundation

class HomePhotosViewModel : NSObject {
    private var apiService : APIManager!
    private(set) var photosData: [PhotoModel]! {
        didSet {
            self.bindPhotosDataToVC()
        }
    }
        
    var searchText : String?
    var apiError : String?
    var bindPhotosDataToVC : (() -> ()) = {}
    
    init(searchText: String) {
        super.init()
        
        self.searchText = searchText
          
        // First, read saved photos from app directory.
        loadSavedPhotos()
        
        // Second, call flicker service and append photos with saved photos if exist.
        // Before append, check if any photos from flicker results are already saved in app directory.
        // if exist then remove from results model.
        apiService = APIManager()
        callFlickerPhotosSearchService()
    }
    
    func loadSavedPhotos() {
        var savedPhotosModel : [PhotoModel] = []
        
        // savedPhotos => is a tuple variable having save photos paths and fileNames
        let savedPhotos = CommonUtilities.loadAllPhotosFromDirectory()
        
        // Saved Photos App Directory Paths
        let photosPath = savedPhotos.photosPath ?? []
        
        // We used flicker photo ID as filename when saving photo
        let photosIDs = savedPhotos.photosIDs ?? []
        
        do {
            for (index, photo) in photosPath.enumerated() {
                let dictModel = ["farm" : -1,
                                 "server" : "",
                                 "id" : photosIDs[index],
                                 "secret" : "",
                                 "title" : "",
                                 "isSavedPhoto" : true,
                                 "savedPhotoPath" : photo] as Dictionary<String, Any>
                
                let modelData = try JSONSerialization.data(withJSONObject: dictModel, options: .prettyPrinted)
                let savedPhotoModel = try JSONDecoder().decode(PhotoModel.self, from: modelData)
                savedPhotosModel.append(savedPhotoModel)
            }
        } catch _ {
            
        }
        
        // self.photosData is a property observer - not called when assign value inside init().
        // So, update the value under dispatch main queue / separate queue.
        DispatchQueue.main.async {
            self.photosData = savedPhotosModel
        }
    }
    
    func callFlickerPhotosSearchService() {
        
        /**
         Flicker Documentation: https://www.flickr.com/services/api/flickr.photos.search.html
         */
        
        let parameters: [String: String] = [
            APIKeys.apiKey: APIConstants.apiKeyValue,
            APIKeys.methodKey: APIConstants.serviceMethod,
            APIKeys.tags: searchText ?? Constants.defaultFlickerSearch,
            APIKeys.formatKey: "json",
            APIKeys.nojsoncallbackKey: "true",
            APIKeys.extrasMedia: APIConstants.extras,
            APIKeys.perPageKey: APIConstants.showLimit,
            APIKeys.pageKey: APIConstants.pageKey
        ]
        
        self.apiService.photosSearchService(parameters: parameters) { (searchResultsModel) in
            
            // Compare Save Photos model with flicker results model.
            // If any photos from flicker are already exist in saved photos then
            // remove it from results model.
            let filteredPhotosModel = self.filterSavedPhotosInSearchResults(searchPhotosModel: searchResultsModel.photos?.photo ?? [])
            self.photosData += filteredPhotosModel
            
        } failed: { (error) in
            self.apiError = error
        }
    }
    
    func filterSavedPhotosInSearchResults(searchPhotosModel: [PhotoModel]) -> [PhotoModel] {
        
        // Flicker photo ID is the filename for saved photo
        // Using photo ID, we remove those photos in flicker results.
        
        let savedPhotosPathsArray = CommonUtilities.loadAllPhotosFromDirectory()
        if savedPhotosPathsArray.photosPath?.count == 0 {
            return searchPhotosModel
        }
        
        let savedPhotosIDs = savedPhotosPathsArray.photosIDs ?? []
        var filteredResults : [PhotoModel]?
        outerLoop: for photoModel in searchPhotosModel {
            for photoID in savedPhotosIDs {
                if photoModel.id == photoID {
                    continue outerLoop
                }
            }
            
            if (filteredResults?.append(photoModel)) == nil {
                filteredResults = [photoModel]
            }
        }
        return filteredResults ?? []
    }
}
