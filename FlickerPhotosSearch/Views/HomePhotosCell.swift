//
//  HomePhotosCell.swift
//  FlickerPhotosSearch
//
//  Created by D MacBook Pro on 13/08/2021.
//

import UIKit

class HomePhotosCell: UICollectionViewCell {
    
    // For caching, subclass UIImageView and handle cache.
    var photoImageView: ImageCacheManager!
    
    var photoValue: PhotoModel? {
        didSet {
            guard let photo = photoValue else {
                return
            }
            
            // Check whether photoValue is saved photos or flicker photos
            if let imagePath = photo.savedPhotoPath, imagePath != "" {
                let image = UIImage.init(contentsOfFile: imagePath)
                photoImageView.image = image
            }
            else if let url = photo.flickrImageURL() {
                photoImageView.loadImageFrom(url: url, placeholder: UIImage.init(systemName: "photo"))
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.photoImageView = ImageCacheManager()
        self.photoImageView?.contentMode = UIView.ContentMode.scaleAspectFit
        self.addSubview(self.photoImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var frame = photoImageView.frame
        frame.size.height = self.frame.size.height
        frame.size.width = self.frame.size.width
        frame.origin.x = 0
        frame.origin.y = 0
        photoImageView.frame = frame
    }
}

extension HomePhotosCell {

   func highlightEffect(){
      self.layer.borderWidth = 3.0
      self.layer.borderColor = UIColor.blue.cgColor
   }

   func removeHighlight(){
      self.layer.borderColor = UIColor.clear.cgColor
   }
}
