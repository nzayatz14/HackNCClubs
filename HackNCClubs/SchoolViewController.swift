//
//  SchoolViewController.swift
//  HackNCClubs
//
//  Created by Nick Zayatz on 10/10/15.
//  Copyright © 2015 Nick Zayatz. All rights reserved.
//

import UIKit

class SchoolViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblClubs: UITableView!
    
    var heightOfHeaderView = UIScreen.mainScreen().bounds.width/2
    
    var clubStrings = ["MACS Club", "Club Basketball", "Club Tennis", "Anime Club", "Chess Club"]
    var clubImages = [UIImage]()
    
    var clubs = [nameAndImagePair]()
    var filteredClubs = [nameAndImagePair]()
    
    var currentSchool = "High Point University"
    
    var selectedClubName = String()
    var selectedClubImage = UIImage()
    
    var searchActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let temp = UIImage(named: "blankImage.png")
        
        for var i = 0 ; i < 5; i++ {
            clubImages.append(temp!)
            var tempClub = nameAndImagePair()
            tempClub.name = clubStrings[i]
            tempClub.image = clubImages[i]
            clubs.append(tempClub)
        }
        
        tblClubs.dataSource = self
        tblClubs.delegate = self
        searchBar.delegate = self
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = "School"
    }
    
    
    //make sure the view only goes into portrait mode
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    
    /**
    Function called to return the number of rows in the table in a given section
    
    - parameter tableView: the table view being described
    - parameter section: the section of the table view being described
    - returns: the number of cells in the section
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(searchActive) {
            return filteredClubs.count
        }
        
        return clubs.count
    }
    
    
    /**
    Function called to return the a cell in a table view at a given index
    
    - parameter tableView: the table view being described
    - parameter indexPath: the index of the cell in the table view
    - returns: the new cell
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ClubTableCell", forIndexPath: indexPath) as! ClubTableCell
        
        //if we are filtering, show filtered results. If not, show all
        if searchActive {
            cell.lblClubName.text = filteredClubs[indexPath.row].name
            cell.imgLogo.image = filteredClubs[indexPath.row].image
        }else{
            cell.lblClubName.text = clubs[indexPath.row].name
            cell.imgLogo.image = clubs[indexPath.row].image
        }
        
        return cell
    }
    
    
    /**
    Function called to return the height of the header of a given section
    
    - parameter tableView: the table view being described
    - parameter section: the section of the table view being described
    - returns: the height of the header view for that section
    */
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightOfHeaderView
    }
    
    
    /**
    Function called to return the header view of a given section
    
    - parameter tableView: the table view being described
    - parameter section: the section of the table view being described
    - returns: the header view for that section
    */
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = CurrentSchoolView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: heightOfHeaderView))
        header.lblCurrentSchoolName.text = currentSchool
        header.lblCurrentSchool.text = "Clubs At"
        
        
        let tap = UITapGestureRecognizer(target: self, action: "headerViewTapped:")
        header.userInteractionEnabled = true
        header.addGestureRecognizer(tap)
        
        return header
    }
    
    
    /**
    Function called when a row in a table view is selected
    
    - parameter tableView: the table view being described
    - parameter indexPath: the index of the row selected
    - returns: void
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        searchBar.resignFirstResponder()
        
        //select things
        if searchActive {
            selectedClubName = filteredClubs[indexPath.row].name
            selectedClubImage = filteredClubs[indexPath.row].image
        }else{
            selectedClubName = clubs[indexPath.row].name
            selectedClubImage = clubs[indexPath.row].image
        }
        
        performSegueWithIdentifier("clkToClubDetails", sender: self)
    }
    
    
    /**
    Function called to prepare for a segue
    
    - parameter segue: the segue being made
    - parameter sender: the sender of the segue
    - returns: void
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "clkToClubDetails" {
            let VC = segue.destinationViewController as! ClubDetailsViewController
            VC.clubName = selectedClubName
            VC.clubImage = selectedClubImage
        }
    }
    
    
    /**
    Function called when the search bar begins editing
    
    - parameter searchBar: the search bar being described
    - returns: void
    */
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    
    /**
    Function called when the search bar ends editing
    
    - parameter searchBar: the search bar being described
    - returns: void
    */
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    
    /**
    Function called when the cancel button is clicked in the search bar
    
    - parameter searchBar: the search bar being described
    - returns: void
    */
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        tblClubs.reloadData()
    }
    
    
    /**
    Function called when the search button is clicked
    
    - parameter searchBar: the search bar being described
    - returns: void
    */
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        searchBar.resignFirstResponder()
    }
    
    
    /**
    Function called when a text field clears
    
    - parameter textField: the text field being described
    - returns: a boolean representing whether or no the action should be allowed
    */
    func textFieldShouldClear(textField: UITextField) -> Bool {
        searchActive = false;
        tblClubs.reloadData()
        return true
    }
    
    
    /**
    Function called when the search bar text changes
    
    - parameter searchBar: the search bar being described
    - parameter searchText: the new text in the search bar
    - returns: void
    */
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        //if text is not empty, filter the results
        if searchBar.text != ""{
            filteredClubs = clubs.filter({ (club: nameAndImagePair) -> Bool in
                let tmp: NSString = club.name
                let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
                return range.location != NSNotFound
            })
        }else{
            filteredClubs = clubs
        }
        
        self.tblClubs.reloadData()
    }
    
    
    /**
    Function called when the header view of the table view si tapped
    
    - parameter sender: the tap gesture
    - returns: void
    */
    func headerViewTapped(sender: UITapGestureRecognizer){
        searchBar.resignFirstResponder()
    }
}
