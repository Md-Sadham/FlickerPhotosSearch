//
//  CommonUtilities.swift
//  FlickerPhotosSearch
//
//  Created by D MacBook Pro on 10/08/2021.
//

import Foundation
import UIKit

class CommonUtilities: NSObject {
      
    // MARK: - Strings and URLs
    static func isValidURL(urlString: String) -> Bool {
        guard URL(string: urlString) != nil else {
            return false
        }
        return true
    }
    
    // MARK: - Alert Methods
    static func showAlert(title : String, message: String, controller : UIViewController)
    {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let alertOKButton = UIAlertAction(title: TitlesMessages.okay, style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(alertOKButton)
            controller.present(alert, animated: true, completion: {
            })
        }
    }
    
    static func showAlertWithDismissHandler(title : String, message: String, controller : UIViewController, alertDismissed:@escaping ((_ okPressed: Bool)->Void))
    {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let alertOKButton = UIAlertAction(title: TitlesMessages.okay, style: UIAlertAction.Style.default, handler: { action in
                alertDismissed(true)
            })
            alert.addAction(alertOKButton)
            controller.present(alert, animated: true, completion: {
            })
        }
    }
    
    static func showAlertWithOptionsAndDismissHandler(title : String, message: String, postiveOption: String, negativeOption: String, controller : UIViewController, alertDismissedWithPos:@escaping ((_ posOptionPressed: Bool)->Void), alertDismissedWithNeg:@escaping ((_ negOptionPressed: Bool)->Void))
    {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            
            if negativeOption != "" {
                let alertNegative = UIAlertAction(title: negativeOption.capitalized, style: UIAlertAction.Style.default, handler: { action in
                    alertDismissedWithNeg(true)
                })
                alert.addAction(alertNegative)
            }
            
            let alertPostive = UIAlertAction(title: postiveOption.capitalized, style: UIAlertAction.Style.default, handler: { action in
                alertDismissedWithPos(true)
            })
            alert.addAction(alertPostive)
            
            controller.present(alert, animated: true, completion: {
            })
        }
    }
    
    // MARK: - Directory
    static func savePhotoToDirectory(image: UIImage, imageName: String) -> (isSuccess: Bool, message: String) {
        
        let defaultFileManager = FileManager.default
        let dirPath = defaultFileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folderPath = dirPath.appendingPathComponent(Constants.savePhotosFolderName)
        
        // Create a folder under document directory if not exist.
        if !defaultFileManager.fileExists(atPath: folderPath.path) {
            do {
                try defaultFileManager.createDirectory(atPath: folderPath.path, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                return (false, "Cannot access the directory. Please try again later.")
            }
        }
        
        // Create file path and write the image on it.
        let filePath = folderPath.appendingPathComponent(imageName)
        if let data = image.jpegData(compressionQuality: 1.0), !defaultFileManager.fileExists(atPath: filePath.path){
            do {
                try data.write(to: filePath)
                return (true, "Photo has been saved to App Directory successfully")
            } catch {
                return (false, error.localizedDescription)
            }
        }
        
        return (false, "Given Directory not exist.")
    }
    
    static func loadAllPhotosFromDirectory() -> (photosPath: [String]?, photosIDs: [String]?, errorMessage: String?) {
        
        let defaultFileManager = FileManager.default
        let dirPath = defaultFileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folderPath = dirPath.appendingPathComponent(Constants.savePhotosFolderName)
        
        var arrPhotosPath : [String]?
        var arrPhotosIDs : [String]?
        do {
            
            let arrPhotosFileNames = try defaultFileManager.contentsOfDirectory(atPath: folderPath.path)
            
            for imageName in arrPhotosFileNames {
                
                // Array of photo paths
                let filePath = folderPath.appendingPathComponent(imageName)
                if (arrPhotosPath?.append(filePath.path)) == nil {
                    arrPhotosPath = [filePath.path]
                }
                
                // Array of photo IDs
                let imageID = imageName.components(separatedBy: ".").first ?? ""
                if (arrPhotosIDs?.append(imageID)) == nil {
                    arrPhotosIDs = [imageID]
                }
            }
                        
            return (arrPhotosPath, arrPhotosIDs, "")
            
        } catch let error as NSError {
            return ([],[], error.localizedDescription)
        }
    }
}
