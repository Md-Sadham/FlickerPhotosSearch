//
//  ActivityIndicator.swift
//  FlickerPhotosSearch
//
//  Created by D MacBook Pro on 16/08/2021.
//

import UIKit

class ActivityIndicator: NSObject {
    let appDelegate = UIApplication.shared.delegate
    var parentView: UIView?

    /*
     If user has not provided view where activity indicator should pop up.
     The default view will be view of the current rootViewController of window.
     */
    var defaultView: UIView? {
        get {
            if let view = self.parentView {
                return view
            } else {
                return appDelegate?.window??.rootViewController?.view
            }
        }
    }

    var activityIndicatorView: UIActivityIndicatorView? {
        get {
            guard let indicatorView = self.defaultView?.superview as? UIActivityIndicatorView else {
                let activityIndicator              = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
                activityIndicator.frame            = CGRect.zero
                activityIndicator.center           = (self.defaultView?.center) ?? CGPoint(x: 0, y: 0)
                activityIndicator.hidesWhenStopped = true
                activityIndicator.tintColor        = .systemBlue
                activityIndicator.startAnimating()
                
                defaultView?.superview?.addSubview(activityIndicator)
                
                return activityIndicator
            }
            return indicatorView
        }
    }

    func start() {
        self.activityIndicatorView?.startAnimating()
    }

    func stop() {
        self.activityIndicatorView?.stopAnimating()
    }
}
