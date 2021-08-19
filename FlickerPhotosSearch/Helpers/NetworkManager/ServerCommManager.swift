//
//  ServerCommManager.swift
//  FlickerPhotosSearch
//
//  Created by D MacBook Pro on 09/08/2021.
//

import Foundation



public class ServerCommManager: NSObject {
    
    let networkReachability = NetworkReachability.shared

    public typealias successCompletion = (_ statusCode: Int, _ respData: Data) -> Void
    public typealias failureCompletion = (_ error : String) -> Void
    
    public override init() {}
    
    public class var sharedInstance : ServerCommManager {
        struct Singleton {
            static let instance = ServerCommManager()
        }
        return Singleton .instance
    }
    
    public func handleAPIRequest(requestInfo: URLRequest,
                                        onSuccess :@escaping successCompletion,
                                        onFailure : @escaping failureCompletion){
        
        // 1 Internet Connection Avail?
//        if !networkReachability.isReachable {
//            onFailure(TitlesMessages.noInternet)
//            return
//        }
        
        // 2 URL Request Settings
       var urlRequest              = requestInfo
        urlRequest.cachePolicy      = .reloadIgnoringCacheData
        
        // 3 Data Task
        let urlSessionConfig    = URLSessionConfiguration.default
        let urlSession          = URLSession(configuration: urlSessionConfig)
        let task    = urlSession.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
                        
            if error != nil {
                onFailure(error!.localizedDescription)
            }
            else if let respData = data {
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                onSuccess(statusCode, respData)
            } else {
                onFailure("Cannot read response from server")
            }
        })
        task.resume();
    }
}
