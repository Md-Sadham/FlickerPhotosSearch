//
//  ActivityIndicator.swift
//  FlickerPhotosSearch
//
//  Created by D MacBook Pro on 16/08/2021.
//

import UIKit

class ActivityIndicator: NSObject {
    var parentView: UIView?

    var activityIndicatorView: UIActivityIndicatorView? {
        get {
            guard let indicatorView = self.parentView?.superview?.viewWithTag(999) as? UIActivityIndicatorView else {
                let activityIndicator              = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
                activityIndicator.frame            = CGRect.zero
                activityIndicator.center           = (self.parentView?.center) ?? CGPoint(x: 0, y: 0)
                activityIndicator.hidesWhenStopped = true
                activityIndicator.tag              = 999
                activityIndicator.tintColor        = .systemBlue
                activityIndicator.startAnimating()
                
                parentView?.superview?.addSubview(activityIndicator)
                
                return activityIndicator
            }
            return indicatorView
        }
    }

    func show(inView: UIView) {
        self.parentView = inView
        self.activityIndicatorView?.startAnimating()
    }

    func stop() {
        self.activityIndicatorView?.stopAnimating()
    }
}
