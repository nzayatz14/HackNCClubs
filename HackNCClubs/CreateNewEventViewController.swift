//
//  CreateNewEventVC.swift
//  HackNCClubs
//
//  Created by Nick Zayatz on 10/11/15.
//  Copyright © 2015 Nick Zayatz. All rights reserved.
//

import UIKit
import EventKit

class CreateNewEventViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var txtEventName: UITextField!
    @IBOutlet weak var txtClubName: UITextField!
    @IBOutlet weak var txtStartTime: UITextField!
    @IBOutlet weak var txtEndTime: UITextField!
    
    let pickerViewClubs = UIPickerView()
    let clubs = ["Club Basketball", "MACS Club", "Club Tennis", "Chess Club", "Anime Club"]
    
    var eventName = String()
    var clubName = String()
    var start = NSDate()
    var end = NSDate()
    
    let datePickerStart = UIDatePicker()
    let datePickerEnd = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtStartTime.delegate = self
        txtEventName.delegate = self
        txtEndTime.delegate = self
        txtClubName.delegate = self
        
        //creating textfields with a pickerview
        pickerViewClubs.delegate = self
        pickerViewClubs.dataSource = self
        pickerViewClubs.frame = CGRectMake(0, 0, self.view.frame.width, 216)
        
        //pickerview tool bar
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.width, 44))
        var items = [UIBarButtonItem]()
        
        //making done button
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "donePressed")
        items.append(doneButton)
        toolbar.barStyle = UIBarStyle.BlackTranslucent
        toolbar.setItems(items, animated: true)
        
        
        datePickerStart.datePickerMode = UIDatePickerMode.DateAndTime
        datePickerStart.addTarget(self, action: "dateChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        datePickerEnd.datePickerMode = UIDatePickerMode.DateAndTime
        datePickerEnd.addTarget(self, action: "dateChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        txtStartTime.inputView = datePickerStart
        txtStartTime.inputAccessoryView = toolbar
        txtEndTime.inputView = datePickerEnd
        txtEndTime.inputAccessoryView = toolbar
        
        txtClubName.inputView = pickerViewClubs
        txtClubName.inputAccessoryView = toolbar
        
        txtEventName.inputAccessoryView = toolbar
        
        setup()
        
    }
    
    
    //make sure the view only goes into portrait mode
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    
    /**
    Function called to setup default inputs
    
    - parameter void:
    - returns: void
    */
    func setup(){
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        
        txtClubName.text = clubs[0]
        clubName = clubs[0]
        
        let dateStringStart = formatter.stringFromDate(datePickerStart.date)
        txtStartTime.text = dateStringStart
        start = datePickerStart.date
        
        let dateStringEnd = formatter.stringFromDate(datePickerEnd.date)
        txtEndTime.text = dateStringEnd
        end = datePickerEnd.date
        
    }
    
    
    /**
    Function called when the create button is pressed
    
    - parameter sender: the button pressed
    - returns: void
    */
    @IBAction func btnCreatePressed(sender: AnyObject) {
        //save information
        
        if validEvent() {
            let store = EKEventStore()
            
            let event = EKEvent(eventStore: store)
            event.title = txtEventName.text!
            event.startDate = start
            event.endDate = end
            event.notes = clubName
            
            let calenderHandler = sharedCalenderHandler
            
            calenderHandler.insertEvent(store, event: event)
            
            //add event to server
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    /**
    Function called when the cancel button is pressed
    
    - parameter sender: the button pressed
    - returns: void
    */
    @IBAction func btnCancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    /**
    Function called to check if an event created is valid
    
    - parameter void:
    - returns: void
    */
    func validEvent() -> Bool{
        
        if (txtEventName.text != "") && (start.timeIntervalSinceDate(end) <= 0) {
            print("valid")
            return true
        }
        
        return false
    }
    
    /**
    If the done button is pressed, resign the first responder.
    
    - parameter void:
    - returns: void
    */
    func donePressed(){
        txtStartTime.resignFirstResponder()
        txtEndTime.resignFirstResponder()
        txtClubName.resignFirstResponder()
        txtEventName.resignFirstResponder()
        
        
    }
    
    
    /**
    Returns the number of sections in the picker view.
    
    - parameter pickerView: the current picker view
    - returns: number of sections in picker view
    */
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    /**
    Returns the number of elements in the current section.
    
    - parameter pickerView: the current picker view
    - parameter component: the current section
    - returns: number of elements in current section
    */
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return clubs.count
    }
    
    
    /**
    Loads the picker view with elements from arrays.
    
    - parameter pickerView: the current picker view
    - parameter row: the current row
    - parameter component: the current section
    - parameter view: the view that may or may not be reused
    - returns: 1 row of the picker view
    */
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        
        //load in the data from the cooresponding array, setting attributes as they are loaded
        let titleData = clubs[row]
        let myTitle = NSAttributedString(string: titleData as String, attributes: [NSFontAttributeName:UIFont(name: "Times" as String, size: 20.0)!])
        pickerLabel.attributedText = myTitle
        pickerLabel.textAlignment = .Center
        return pickerLabel
    }
    
    
    /**
    Handles when the user selects a row in a picker view.
    
    - parameter pickerView: the current picker view
    - parameter row: the current row
    - parameter component: the current section
    - returns: void
    */
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        txtClubName.text = clubs[row]
        clubName = clubs[row]
    }
    
    
    /**
    Function called when the date changed
    
    - parameter sender: the date picker object changed
    - returns: void
    */
    func dateChanged(sender: AnyObject){
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        
        if sender as! NSObject == datePickerStart {
            let dateString = formatter.stringFromDate(datePickerStart.date)
            txtStartTime.text = dateString
            start = datePickerStart.date
        } else {
            let dateString = formatter.stringFromDate(datePickerEnd.date)
            txtEndTime.text = dateString
            end = datePickerEnd.date
        }
    }
    
}
