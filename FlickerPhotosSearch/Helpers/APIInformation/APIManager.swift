//
//  APIManager.swift
//  FlickerPhotosSearch
//
//  Created by D MacBook Pro on 09/08/2021.
//

import Foundation

class APIManager: NSObject {
    
    func photosSearchService(parameters: [String : String],
        success:@escaping ((_ response : SearchResultsModel) ->Void),
        failed:@escaping ((_ error : String) -> Void))
    {
        print("++++++ SEARCH ARTICLES API - STARTED ++++++")
        
        let baseURLString = APIConstants.baseURLString
        if !CommonUtilities.isValidURL(urlString: baseURLString) {
            failed("Invalid Base URL")
        }
        
        var urlComponents: URLComponents = URLComponents(string: baseURLString)!
        urlComponents.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        print("Request URL: ", urlComponents.url ?? "--INVALID URL--")
        
        let request = NetworkSettings.request(method: .GET, url: urlComponents.url!)
                
        let serverCommObj = ServerCommManager.sharedInstance
        serverCommObj.handleAPIRequest(requestInfo: request, onSuccess: { (statusCode, jsonData) in
            do {
                let respModel = try JSONDecoder().decode(SearchResultsModel.self, from: jsonData)
                if respModel.stat?.lowercased() == "ok" {
                    print("++++++ API - SUCCESS ++++++")
                    
                    success(respModel)
                    return
                }
                
                print("++++++ API - FAILED ++++++")
                failed("No Photos found")
                
            } catch let error {
                print("ERROR WHEN DECODE: ", error)
                failed("BAD RESPONSE")
            }
        }, onFailure: { (error) in
            failed(error.localizedCapitalized)
        })
    }
    
}
