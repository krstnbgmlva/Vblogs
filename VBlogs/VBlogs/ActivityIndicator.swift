//
//  UIViewController+ActivityIndicator.swift
//  VBlogs
//
//  Created by Kristina Bogomolova on 5/9/16.
//  Copyright © 2016 FoxyLabs. All rights reserved.
//

import UIKit

class ActivityIndicator {
    
    static var activityIndicator: UIImageView? {
        if let appDelegate = UIApplication.sharedApplication().delegate, w = appDelegate.window, window = w {
            if let spinner = window.viewWithTag(3432547) as? UIImageView {
                return spinner
            } else {
                let spinner = UIImageView(frame: CGRectMake(100, 100, 60, 60))
                spinner.center = window.center
                var images = [UIImage]()
                for i in 1...18 {
                    if let img = UIImage(named: "panda\(i)") {
                        images.append(img)
                    }
                }
                spinner.tag = 3432547
                spinner.animationImages = images
                spinner.animationDuration = 2
                window.addSubview(spinner)
                return spinner
            }
        }
        return nil
    }
    
    class func show() {
        if let spinner = self.activityIndicator {
            spinner.hidden = false
            spinner.startAnimating()
        }
    }
    
    class func hide() {
        if let spinner = self.activityIndicator {
            spinner.hidden = true
            spinner.stopAnimating()
        }
    }

}
