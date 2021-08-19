//
//  ImageCacheManager.swift
//  FlickerPhotosSearch
//
//  Created by D MacBook Pro on 10/08/2021.
//

import Foundation
import UIKit

class ImageCacheManager: UIImageView {
    
    //MARK: - Variables
    private var currentURL: NSString?
    
    //MARK: - Methods
    func loadImageFrom(url: String, placeholder: UIImage?) {
        let imageURL = url as NSString
        if let cachedImage = AppDelegate.getAppDelegateInstance()?.imagesCacheArray.object(forKey: imageURL) {
            // Image Read from cache
            image = cachedImage
            return
        }
        
        image       = placeholder
        currentURL  = imageURL
        
        guard let requestURL = URL(string: url) else { image = placeholder; return }
        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            DispatchQueue.main.async { [weak self] in
                if error == nil {
                    if let imageData = data {
                        if self?.currentURL == imageURL {
                            if let imageToPresent = UIImage(data: imageData) {
                                AppDelegate.getAppDelegateInstance()?.imagesCacheArray.setObject(imageToPresent, forKey: imageURL)
                                self?.image = imageToPresent
                            } else {
                                self?.image = placeholder
                            }
                        }
                    } else {
                        self?.image = placeholder
                    }
                } else {
                    self?.image = placeholder
                }
            }
            }.resume()
    }
}

