//
//  ProfileViewController.swift
//  HackNCClubs
//
//  Created by Nick Zayatz on 10/10/15.
//  Copyright © 2015 Nick Zayatz. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Profile did load")
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, picture.type(large)"]).startWithCompletionHandler({connection, result, error in
                if (error == nil) {
                    let resultDict = result as! NSDictionary
                    
                    //get name, id, and pic data
                    let name = resultDict.objectForKey("name") as! String
                    let id = resultDict.objectForKey("id") as! String
                    let picDict = resultDict.objectForKey("picture") as! NSDictionary
                    let picDataDict = picDict.objectForKey("data") as! NSDictionary
                    let picString = picDataDict.objectForKey("url") as! String
                    let picURL = NSURL(string: picString)
                    let picData = NSData(contentsOfURL: picURL!)
                    
                    let image = UIImage(data: picData!)
                    
                    self.lblName.text = name
                    self.imgProfilePic.image = image
                    
                    print("\(resultDict)")
                }else{
                    print("Error - \(error.description)")
                }
            })
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = "Profile"
    }
    
    
    //make sure the view only goes into portrait mode
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    
    override func viewDidLayoutSubviews() {
        self.imgProfilePic.layer.cornerRadius = self.imgProfilePic.frame.width/2
        self.imgProfilePic.layer.masksToBounds = true
        self.imgProfilePic.layer.borderColor = UIColor.whiteColor().CGColor
        self.imgProfilePic.layer.borderWidth = 1.5
    }
    
}
