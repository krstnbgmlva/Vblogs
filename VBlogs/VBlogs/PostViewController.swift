//
//  PostViewController.swift
//  VBlogs
//
//  Created by Kristina Bogomolova on 4/27/16.
//  Copyright © 2016 FoxyLabs. All rights reserved.
//

//
//  PostViewController.swift
//  VBlogs
//
//  Created by Kristina Bogomolova on 4/27/16.
//  Copyright © 2016 FoxyLabs. All rights reserved.
//

import UIKit
import SafariServices

class PostViewController: SFSafariViewController, SFSafariViewControllerDelegate {
    
    var post = [String: AnyObject]()
    var linkToPost = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

        self.updateFavoritesIcon()
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        self.navigationItem.backBarButtonItem = backItem
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        ActivityIndicator.show()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        ActivityIndicator.hide()
    }
    
    private func updateFavoritesIcon() {
        if Favorites.checkIfInFavorites(self.linkToPost) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"HeartFull.png"), style: .Plain, target: self, action: #selector(removeFromFav))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"HeartEmpty.png"), style: .Plain, target: self, action: #selector(addToFav))
        }
    }
    
    func addToFav() {
        Favorites.addToFavorites(self.post)
        self.updateFavoritesIcon()
    }
    
    func removeFromFav() {
        Favorites.removeFromFavorites(self.post)
        self.updateFavoritesIcon()
    }
    
    func safariViewController(controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        ActivityIndicator.hide ()
    }
}