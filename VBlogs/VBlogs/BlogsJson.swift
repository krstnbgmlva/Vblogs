//
//  BlogsManager.swift
//  VBlogs
//
//  Created by Kristina Bogomolova on 4/12/16.
//  Copyright © 2016 FoxyLabs. All rights reserved.
//

import Foundation

class BlogsJson {
    
    static var blogsGeneral = [String: AnyObject]()
    
    class func readJsonFile() {
        let bundle = NSBundle.mainBundle()
        let blogsFilePath = bundle.pathForResource("blogs", ofType: "json")!
        guard let data = NSData(contentsOfFile: blogsFilePath) else { return }
        
        do {
            if let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] {
                self.blogsGeneral = json
            } else {
                print("Unwrapping optional error")
            }
        } catch {
            print("Json serialization error")
        }
    }
}