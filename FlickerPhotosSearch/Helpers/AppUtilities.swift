//
//  AppUtilities.swift
//  FlickerPhotosSearch
//
//  Created by D MacBook Pro on 10/08/2021.
//

import Foundation

enum Constants {
    static let bit8 = 8
    static let defaultFlickerSearch     = "Electrolux"
    static let photosCellID             = "HomePhotosCellID"
    static let savePhotosFolderName     = "SavedPhotos"
}

struct TitlesMessages {
    
    // Titles
    static let notAvailable             = "-NA-"
    static let okay                     = "Okay"
    static let cancel                   = "Cancel"
    static let pleaseWait               = "Please wait..."
    static let warning                  = "Warning"
    static let failed                   = "Failed"
    static let success                  = "Success"
    static let notice                   = "Notice"
    
    // Messages
    static let badRequest               = "Bad Request"
    static let badResponse              = "Encountered an error while trying to connect to the server"
    static let cantReadResponse         = "Cannot read the response from server"
    static let noInternet               = "No Internet Connection available"
}
