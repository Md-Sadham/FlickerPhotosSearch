//
//  APIConstants.swift
//  FlickerPhotosSearch
//
//  Created by D MacBook Pro on 10/08/2021.
//

import Foundation

struct APIConstants {
    
    // Flicker Domain
    static let baseURLString    = "https://api.flickr.com/services/rest"
    
    // Flicker Credentials:
    // Not recommended to save here.
    // Better way to get from server and save it in Keychain.
    static let secret           = "7bb62ea7a0595dbd"
    static let apiKeyValue      = "08d5d54cde82f56aae71207ed2551ecf"

    // Flicker Arguments
    static let serviceMethod    = "flickr.photos.search"
    static let extras           = "media,url_sq,url_m"
    static let showLimit        = "21"
    static let pageKey          = "1"
}
