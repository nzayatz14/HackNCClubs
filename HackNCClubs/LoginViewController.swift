//
//  LoginViewController.swift
//  HackNCClubs
//
//  Created by Nick Zayatz on 10/10/15.
//  Copyright © 2015 Nick Zayatz. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet var btnLogin: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnLogin.delegate = self
        btnLogin.readPermissions = ["public_profile", "email", "user_friends"]
        
        print("wassup guys")
    }
    
    
    /**
    Delegate function called with the user finishes a login for facebook
    
    - parameter loginButton: the button pressed
    - parameter result: the result of of the login
    - parameter error: the error of the login if there is one
    - returns: void
    */
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if error == nil {
            if result.isCancelled == false {
                performSegueWithIdentifier("clkToMainMenu", sender: self)
            }else{
                print("Error - login cancelled")
            }
        }else{
            print("Error - \(error.localizedDescription)")
        }
    }
    
    
    /**
    Function called when we are preparing to login
    
    - parameter loginButton: the button pressed
    - returns: a boolean that determines whether or not to let the user login
    */
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    
    /**
    Function called when the user finishes logging out
    
    - parameter loginButton: the button pressed
    - returns: void
    */
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    
    /**
    Prepare for segue
    
    - parameter segue: the segue we are preparing for
    - parameter sender: the sender of the segue
    - returns: void
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "clkToMainMenu" {
        
        }
    }
}
