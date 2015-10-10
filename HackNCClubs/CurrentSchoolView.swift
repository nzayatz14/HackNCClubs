//
//  CurrentSchoolView.swift
//  HackNCClubs
//
//  Created by Nick Zayatz on 10/10/15.
//  Copyright © 2015 Nick Zayatz. All rights reserved.
//

import UIKit

class CurrentSchoolView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var lblCurrentSchool: UILabel!
    @IBOutlet weak var lblCurrentSchoolName: UILabel!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NSBundle.mainBundle().loadNibNamed("CurrentSchoolView", owner: self, options: nil)
        
        self.addSubview(self.view)
        
        setup()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NSBundle.mainBundle().loadNibNamed("CurrentSchoolView", owner: self, options: nil)
        
        self.frame = frame
        self.view.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        
        self.addSubview(self.view)
        
        setup()
    }
    
    
    /**
    Setup function to set initialize properties of the view
    
    - parameter void:
    - returns: void
    */
    func setup(){
        lblCurrentSchool.adjustsFontSizeToFitWidth = true
        lblCurrentSchoolName.adjustsFontSizeToFitWidth = true
    }
    
}
