//
//  CommonUtilities.swift
//  FlickerPhotosSearch
//
//  Created by D MacBook Pro on 10/08/2021.
//

import Foundation
import UIKit

class CommonUtilities: NSObject {
        
    static func isValidURL(urlString: String) -> Bool {
        guard URL(string: urlString) != nil else {
            return false
        }
        return true
    }
    
    static func eightBitMultiples(value: Int) -> Int {
        return value*8
    }
    
    // MARK: - Alert Methods
    static func showAlert(title : String, message: String, controller : UIViewController)
    {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let alertOKButton = UIAlertAction(title: TitlesMessages.okay, style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(alertOKButton)
            controller.present(alert, animated: true, completion: {
                print("Alert presented success-1");
            })
        }
    }
    
    static func showAlertWithDismissHandler(title : String, message: String, controller : UIViewController, alertDismissed:@escaping ((_ okPressed: Bool)->Void))
    {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let alertOKButton = UIAlertAction(title: TitlesMessages.okay, style: UIAlertAction.Style.default, handler: { action in
                print("Alert Dismissed")
                alertDismissed(true)
            })
            alert.addAction(alertOKButton)
            controller.present(alert, animated: true, completion: {
                print("Alert presented success-2");
            })
        }
    }
    
    static func showAlertWithOptionsAndDismissHandler(title : String, message: String, postiveOption: String, negativeOption: String, controller : UIViewController, alertDismissedWithPos:@escaping ((_ posOptionPressed: Bool)->Void), alertDismissedWithNeg:@escaping ((_ negOptionPressed: Bool)->Void))
    {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            
            if negativeOption != "" {
                let alertNegative = UIAlertAction(title: negativeOption.capitalized, style: UIAlertAction.Style.default, handler: { action in
                    print("Alert Dismissed with negative option")
                    alertDismissedWithNeg(true)
                })
                alert.addAction(alertNegative)
            }
            
            let alertPostive = UIAlertAction(title: postiveOption.capitalized, style: UIAlertAction.Style.default, handler: { action in
                print("Alert Dismissed with postive option")
                alertDismissedWithPos(true)
            })
            alert.addAction(alertPostive)
            
            controller.present(alert, animated: true, completion: {
                print("Alert presented success-3");
            })
        }
    }
    
    // MARK: - Directory
    static func savePhotoToDirectory(image: UIImage, imageName: String) -> (isSuccess: Bool, message: String) {
        print("Preparing to save image ===")
        
        let defaultFileManager = FileManager.default
        let dirPath = defaultFileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folderPath = dirPath.appendingPathComponent(Constants.savePhotosFolderName)
        
        // Create a folder under document directory
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
                print("file saved at path: \(filePath.path)")
                return (true, "File has been saved successfully")
            } catch {
                print("error saving file:", error)
                return (false, error.localizedDescription)
            }
        }
        return (false, "Folder not exists.")
    }
    
    static func loadAllPhotosFromDirectory() -> (photosPath: [String]?, photosIDs: [String]?, errorMessage: String?) {
        print("Preparing to save image ===")
        
        let defaultFileManager = FileManager.default
        let dirPath = defaultFileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folderPath = dirPath.appendingPathComponent(Constants.savePhotosFolderName)
        
        var arrPhotosPath : [String]?
        var arrPhotosIDs : [String]?
        do {
            
            let arrPhotosFileNames = try defaultFileManager.contentsOfDirectory(atPath: folderPath.path)
            print("ALL PHOTOS Names: ", arrPhotosFileNames)
            
            for imageName in arrPhotosFileNames {
                
                // Array of images paths
                let filePath = folderPath.appendingPathComponent(imageName)
                if (arrPhotosPath?.append(filePath.path)) == nil {
                    arrPhotosPath = [filePath.path]
                }
                
                // Array of images IDs
                let imageID = imageName.components(separatedBy: ".").first ?? ""
                if (arrPhotosIDs?.append(imageID)) == nil {
                    arrPhotosIDs = [imageID]
                }
            }
            print("ALL PHOTOS PATH: ", arrPhotosPath ?? [])
            print("ALL PHOTOS IDs: ", arrPhotosIDs ?? [])
                        
            return (arrPhotosPath, arrPhotosIDs, "")
            
        } catch let error as NSError {
            print(error.localizedDescription)
            return ([],[], error.localizedDescription)
        }
    }
}