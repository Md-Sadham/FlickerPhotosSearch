//
//  APIKeys.swift
//  FlickerPhotosSearch
//
//  Created by D MacBook Pro on 10/08/2021.
//

import Foundation

/**
 https://api.flickr.com/services/rest?api_key={0}&method={1}&tags={2}&format=json&nojsoncallback=true&extras=media&extras=url_sq&extras=url_m&per_page=20&page=1
 
 {0} – API Key
 {1} – service name, please use `flickr.photos.search`
 {2} – the search tag, e.g., Electrolux

 */

struct APIKeys {
    // TODO: Make order of below variables from code assignment pdf
    static let apiKey = "api_key"
    static let methodKey = "method"
    static let tags = "tags"
    static let formatKey = "format"
    static let nojsoncallbackKey = "nojsoncallback"
    static let extrasMedia = "extras"
    static let extrasURLSq = "extras" // error
    static let extrasURLM = "extras" // error
    static let perPageKey = "per_page"
    static let pageKey = "page"
}
