//
//  TableViewController.swift
//  VBlogs
//
//  Created by Kristina Bogomolova on 4/7/16.
//  Copyright © 2016 FoxyLabs. All rights reserved.
//

import UIKit
import SafariServices

class TableViewController: UITableViewController {
    
    private var posts = [[String: AnyObject]]()
    private var isFavorites: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData(0)
        guard Reachability.isConnectedToNetwork() else {
            print("Internet connection not available")
            let alert = UIAlertController(title: "No Internet connection", message: "Please ensure you are connected to the Internet", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.isFavorites{
            self.displayFavorites()
        }
    }
    
    func displayFavorites() {
        self.isFavorites = true
        self.title = "Favorites"
        Favorites.getUserDefaults()
        self.posts = Favorites.favorites
        self.tableView.reloadData()
    }
    
    func reloadData(i: Int) {
        self.isFavorites = false
        
        guard let parser = BlogsJson.blogsGeneral["parser"] as? String else {
            return
        }
        
        guard let blogsInfo = BlogsJson.blogsGeneral["feeds"] as? [[String: String]] else {
            return
        }
        
        let blog = blogsInfo[i]
        self.title = blog["title"]
        
        let blogsInfoEntry = blogsInfo[i]
        guard let blogUrl = blogsInfoEntry["url"] else {
            return
        }
        
        self.posts.removeAll()
        self.tableView.reloadData()
        
        guard let url = NSURL(string: parser + blogUrl) else {
            return
        }
        
        ActivityIndicator.show()
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url) { (data, response, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                ActivityIndicator.hide()
                if error != nil {
                    print("Error")
                } else {
                    if let data = data {
                        do {
                            guard let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary else { return }
                            
                            if jsonResult.count > 0 {
                                if let responseData = jsonResult["responseData"] as? [String: AnyObject],
                                    feed = responseData["feed"] as? [String: AnyObject],
                                    entries = feed["entries"] as? [[String: AnyObject]] {
                                    self.posts = entries.map {
                                        return ["title": $0["title"] ?? "", "link": $0["link"] ?? "", "author": $0["author"] ?? ""]
                                    }
                                    self.tableView.reloadData()
                                }
                            }
                        } catch { print("Serialization failed") }
                    }
                }
            })
        }
        task.resume()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        self.navigationItem.backBarButtonItem = backItem
    }
    
    @IBAction func LeftSideMenuTapped(sender: AnyObject) {
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MainCell")
        cell.backgroundColor = UIColor.clearColor()
        let post = self.posts[indexPath.row]
        if let label = cell.textLabel, detail = cell.detailTextLabel {
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.ByWordWrapping
            label.font = UIFont(name: "Chalkboard SE", size:19)
            label.text = post["title"] as? String
            if self.isFavorites {
                if let subtitle = post["author"] as? String {
                    detail.text = "by " + subtitle
                    detail.font = UIFont(name: "Chalkboard SE", size:13)
                }
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let post = self.posts[indexPath.row]
        guard let linkToPost = post["link"] as? String, link = NSURL(string: linkToPost) else {
            return
        }
        
        let sfVC = PostViewController(URL: link, entersReaderIfAvailable: true)
        sfVC.post = post
        sfVC.linkToPost = linkToPost
        self.navigationController?.pushViewController(sfVC, animated: true)
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return self.isFavorites
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let post = self.posts[indexPath.row]
            Favorites.removeFromFavorites(post)
            self.displayFavorites()
        }
    }
}
