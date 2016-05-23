//
//  LeftViewController.swift
//  VBlogs
//
//  Created by Kristina Bogomolova on 4/7/16.
//  Copyright © 2016 FoxyLabs. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(-60.0, 0.0, 0.0, 0.0)
        self.title = "Vegan Blogs"
    }
    
    //MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let blogsInfo = BlogsJson.blogsGeneral["feeds"] as? [[String: String]] else {
            return 1
        }
        return blogsInfo.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "FavoritesCell")
            cell.backgroundColor = UIColor.clearColor()
            cell.textLabel!.font = UIFont(name: "Chalkduster", size:20)
            cell.textLabel?.text = "Favorites"
            return cell
        } else {
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "LeftCell")
            guard let blogsInfo = BlogsJson.blogsGeneral["feeds"] as? [[String: String]] else {
                return cell
            }
            let blog = blogsInfo[indexPath.row - 1]
            cell.backgroundColor = UIColor.clearColor()
            cell.textLabel!.font = UIFont(name: "Chalkboard SE", size:19)
            cell.textLabel?.text = blog["title"]
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard Reachability.isConnectedToNetwork() else {
            let alert = UIAlertController(title: "No Internet connection", message: "Please ensure you are connected to the Internet", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        let deleg = UIApplication.sharedApplication().delegate as! AppDelegate
        if indexPath.row == 0 {
            deleg.centerViewController?.displayFavorites()
        } else {
            deleg.centerViewController?.reloadData(indexPath.row - 1)
        }
        deleg.centerContainer?.closeDrawerAnimated(true, completion: nil)
    }
}
