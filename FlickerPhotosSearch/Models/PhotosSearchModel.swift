//
//  PhotosSearchModel.swift
//  FlickerPhotosSearch
//
//  Created by D MacBook Pro on 09/08/2021.
//

import Foundation

// MARK: - SearchResultsModel
struct SearchResultsModel: Codable {
    let photos: PhotosResultsModel?
    let stat: String?
}

// MARK: - Photos
struct PhotosResultsModel: Codable {
    let photo: [PhotoModel]?
}

// MARK: - Photo
struct PhotoModel: Codable {
    
    let server, id, secret: String?
    
    // Below two are own variables. Use it for save photos feature.
    let isSavedPhoto: Bool?
    let savedPhotoPath: String?

    enum CodingKeys: String, CodingKey {
        case server, id, secret
        case isSavedPhoto, savedPhotoPath
    }
    
    func flickrImageURL() -> String? {
        
        /**
         Flicker Documentation: https://www.flickr.com/services/api/misc.urls.html
         Describe how to prepare static image URL
         */
        
        if
            let server = self.server,
            let id = self.id,
            let secret = self.secret {
            let url =  "https://live.staticflickr.com/\(server)/\(id)_\(secret)_m.jpg"
            return url
        }
        return nil
    }
}

