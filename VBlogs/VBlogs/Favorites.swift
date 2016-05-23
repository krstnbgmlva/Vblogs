//
//  Favorites.swift
//  VBlogs
//
//  Created by Kristina Bogomolova on 4/27/16.
//  Copyright © 2016 FoxyLabs. All rights reserved.
//

import Foundation

class Favorites {
    
    static var favorites = [[String: AnyObject]]()
    
    class func getUserDefaults() {
        if let favUserDef = NSUserDefaults.standardUserDefaults().objectForKey("favorites") as? [[String: AnyObject]] {
            self.favorites = favUserDef
        }
    }
    
    class func saveUserDefaults() {
        NSUserDefaults.standardUserDefaults().setObject(favorites, forKey: "favorites")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func checkIfInFavorites(postLink: String) -> Bool {
        self.getUserDefaults()
        for x in favorites {
            if let favLink = x["link"] as? String {
                if  favLink == postLink {
                    return true
                }
            }
        }
        return false
    }
    
    class func addToFavorites(post: [String: AnyObject]) {
        self.favorites.append(post)
        self.saveUserDefaults()
    }
    
    class func removeFromFavorites(post: [String: AnyObject]){
        for i in 0 ..< self.favorites.count {
            var x = self.favorites[i]
            if let favItemLink = x["link"] as? String {
                if let postItemLink = post["link"] as? String {
                    if favItemLink == postItemLink {
                        favorites.removeAtIndex(i)
                        saveUserDefaults()
                        return
                    }
                }
            }
        }
    }
}

