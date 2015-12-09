//
//  GroupsViewController.swift
//  Shares
//
//  Created by Dan Xiaoyu Yu on 12/2/15.
//  Copyright © 2015 Corner Innovations LLC. All rights reserved.
//


import Foundation
import UIKit
import Parse
import MBProgressHUD


// **********************************
// MARK: - SearchGroupsViewController
// **********************************


class SearchGroupsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

  
  // *****************************************
  // MARK: - Variables, Outlets, and Constants
  // *****************************************
  
  
  @IBOutlet weak var tableView: UITableView!
  var searchActive: Bool = false
  var data: [PFObject]!
  var filtered: [PFObject]!
  
  
  // **************************
  // MARK: - View Configuration
  // **************************
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    search()
  }
  
  
  // ***************************
  // MARK: - Parse Configuration
  // ***************************
  
  
  /*
  *  Function: joinGroup(sender)
  *  ---------------------------
  *  Alternative to picker view that looks nicer. Instead of having a picker view in a table view
  *  cell, allow a custom picker view to move onto the screen, allowing the user to select industry.
  */
  func joinGroup(sender: UIButton) {
    let group = self.data[sender.tag]
    group.addUniqueObject(CURRENT_USER, forKey: "members")
    
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    
    group.saveInBackgroundWithBlock() { (success, error) -> Void in
      if error == nil {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        
        let alertController = UIAlertController(
          title: "Success",
          message: "You have successfully been added to the group. Please check your groups.",
          preferredStyle: .Alert
        )
        
        alertController.addAction(UIAlertAction(
          title: "Continue",
          style: .Default,
          handler: nil
          ))
        self.presentViewController(alertController, animated: true, completion: nil)
        
        self.performSegueWithIdentifier("groupAddedSuccess", sender: self)
        
      } else {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        if let errorString = error!.userInfo["error"] as? NSString {
          
          let alertController = UIAlertController(
            title: "Error",
            message: errorString as String,
            preferredStyle: .Alert
          )
          
          alertController.addAction(UIAlertAction(
            title: "Continue",
            style: .Default,
            handler: nil
            ))
          self.presentViewController(alertController, animated: true, completion: nil)
        }
      }
    }
  }
  
  
  // ********************************
  // MARK: - Search Bar Configuration
  // ********************************
  
  
  func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
    searchActive = true;
  }
  
  func searchBarTextDidEndEditing(searchBar: UISearchBar) {
    searchActive = false;
  }
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    searchActive = false;
  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchActive = false;
  }
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    search(searchText)
  }
  
  func search(searchText: String? = nil){
    let query = PFQuery(className: "Groups")
    if (searchText != nil) {
      query.whereKey("groupname", containsString: searchText!.lowercaseString)
    }
    query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
      self.data = results! as [PFObject]
      self.tableView.reloadData()
    }
  }
  
  
  // ********************************
  // MARK: - Table View Configuration
  // ********************************
  
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 80
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.data != nil ? self.data.count : 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

    if self.data != nil && self.data.count != 0 {
      
      let group = self.data[indexPath.row]
      let cell = tableView.dequeueReusableCellWithIdentifier("SearchGroupCell", forIndexPath: indexPath) as! SearchGroupCell
      
      cell.groupnameLabel!.text = group["groupname"] as? String
      cell.groupTaglineLabel!.text = group["tagline"] as? String
      cell.numMembersLabel!.text = "(" + String(group["members"].count) + " members)"
      cell.joinButton.tag = indexPath.row
      cell.joinButton.addTarget(self, action: "joinGroup:", forControlEvents: .TouchUpInside)
      return cell
      
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier("SearchNoneCell", forIndexPath: indexPath)
      return cell
    }
  }
}
