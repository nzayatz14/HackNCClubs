//
//  ClubDetailsViewController.swift
//  HackNCClubs
//
//  Created by Nick Zayatz on 10/10/15.
//  Copyright © 2015 Nick Zayatz. All rights reserved.
//

import UIKit

class ClubDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblClubName: UILabel!
    
    
    var clubName = String()
    var clubImage = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        imgLogo.image = clubImage
        lblClubName.text = clubName
    }
    
    
    //make sure the view only goes into portrait mode
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    
}
