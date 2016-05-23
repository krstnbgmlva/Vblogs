//
//  AboutViewController.swift
//  VBlogs
//
//  Created by Kristina Bogomolova on 4/20/16.
//  Copyright © 2016 FoxyLabs. All rights reserved.
//

import UIKit
import MessageUI

class AboutViewController: UIViewController, MFMailComposeViewControllerDelegate, UIWebViewDelegate {
    
    @IBOutlet weak var aboutWebView: UIWebView!
    
    override func viewDidLoad() {
        self.aboutWebView.delegate = self
        navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Chalkduster", size: 21)!]
        let localfilePath = NSBundle.mainBundle().URLForResource("About", withExtension: "html");
        let myRequest = NSURLRequest(URL: localfilePath!)
        self.aboutWebView.loadRequest(myRequest)
    }

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if navigationType == .LinkClicked {
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
        }
        return true
    }
    
    @IBAction func sendEmail(sender: AnyObject) {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["support@foxylabs.com"])
        mailComposerVC.setSubject("Feedback on Vblog app")
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposerVC, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
   private func showSendMailErrorAlert() {
        let alert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail. Please check e-mail configuration and try again.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
