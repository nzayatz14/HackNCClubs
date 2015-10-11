//
//  HomeViewController.swift
//  HackNCClubs
//
//  Created by Nick Zayatz on 10/10/15.
//  Copyright © 2015 Nick Zayatz. All rights reserved.
//

import UIKit
import EventKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tblEvents: UITableView!
    
    var events = [EKEvent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblEvents.dataSource = self
        tblEvents.delegate = self
        
        let calenderHandler = sharedCalenderHandler
        var store = EKEventStore()
        
        for var i = 0 ; i < 5 ; i++ {
            let temp = EKEvent(eventStore: store)
            temp.title = "Event\(i)"
            temp.startDate = NSDate().dateByAddingTimeInterval(Double(i) * 60 * 60)
            temp.endDate = NSDate().dateByAddingTimeInterval(Double(i) * 60 * 60 + 10)
            events.append(temp)
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = "Home"
    }
    
    
    //make sure the view only goes into portrait mode
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    
    /**
    Action triggered when the add event button is pressed
    
    - parameter sender: the button pressed
    - returns: void
    */
    @IBAction func btnAddEventPressed(sender: AnyObject) {
        
    }
    
    
    /**
    Function called to return the number of rows in the table in a given section
    
    - parameter tableView: the table view being described
    - parameter section: the section of the table view being described
    - returns: the number of cells in the section
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return events.count
    }
    
    
    /**
    Function called to return the a cell in a table view at a given index
    
    - parameter tableView: the table view being described
    - parameter indexPath: the index of the cell in the table view
    - returns: the new cell
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeTableCell", forIndexPath: indexPath) as! HomeTableCell
        
        cell.lblEventTitle.text = events[indexPath.row].title
        cell.lblClubTitle.text = events[indexPath.row].calendar.description
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        
        let dateString = formatter.stringFromDate(events[indexPath.row].startDate)
         cell.lblDateAndTime.text = dateString
        
        return cell
    }
    
    
}
