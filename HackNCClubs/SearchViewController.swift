//
//  SearchViewController.swift
//  HackNCSchools
//
//  Created by Nick Zayatz on 10/10/15.
//  Copyright © 2015 Nick Zayatz. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblSchools: UITableView!
    
    var heightOfHeaderView = UIScreen.mainScreen().bounds.width/2
    
    var schoolStrings = ["High Point University", "Duke University", "University of North Carolina, Chapel Hill", "University of North Carolina, Asheville", "Wake Forest University"]
    var schoolImages = [UIImage]()
    
    var schools = [nameAndImagePair]()
    var filteredSchools = [nameAndImagePair]()
    
    var currentSchool = "High Point University"
    
    var searchActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let temp = UIImage(named: "blankImage.png")
        
        for var i = 0 ; i < 5; i++ {
            schoolImages.append(temp!)
            var tempSchool = nameAndImagePair()
            tempSchool.name = schoolStrings[i]
            tempSchool.image = schoolImages[i]
            schools.append(tempSchool)
        }
        
        
        tblSchools.dataSource = self
        tblSchools.delegate = self
        searchBar.delegate = self
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = "Search"
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
            return filteredSchools.count
        }
        
        return schools.count
    }
    
    
    /**
    Function called to return the a cell in a table view at a given index
    
    - parameter tableView: the table view being described
    - parameter indexPath: the index of the cell in the table view
    - returns: the new cell
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SchoolTableCell", forIndexPath: indexPath) as! SchoolTableCell
        
        //if we are filtering, show filtered results. If not, show all
        if searchActive {
            cell.lblCollegeName.text = filteredSchools[indexPath.row].name
            cell.imgLogo.image = filteredSchools[indexPath.row].image
        }else{
            cell.lblCollegeName.text = schools[indexPath.row].name
            cell.imgLogo.image = schools[indexPath.row].image
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
        tblSchools.reloadData()
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
        tblSchools.reloadData()
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
            filteredSchools = schools.filter({ (school: nameAndImagePair) -> Bool in
                let tmp: NSString = school.name
                let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
                return range.location != NSNotFound
            })
        }else{
            filteredSchools = schools
        }
        
        self.tblSchools.reloadData()
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
