//
//  GroupsViewController.swift
//  Shares
//
//  Created by Dan Xiaoyu Yu on 12/2/15.
//  Copyright © 2015 Corner Innovations LLC. All rights reserved.
//


import Foundation
import UIKit
import MBProgressHUD
import Parse
import ParseFacebookUtilsV4


// ****************************
// MARK: - GroupsViewController
// ****************************


class GroupsViewController: UITableViewController {
  
  
  // *****************************************
  // MARK: - Variables, Outlets, and Constants
  // *****************************************
  
  
  var data: [PFObject]!
  var filtered: [PFObject]!
  
  
  // *************************************
  // MARK: - View Controller Configuration
  // *************************************
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadGroups()
  }
  
  
  // **************************
  // MARK: - Parse Data Methods
  // **************************
  
  
  func loadGroups(){
    let query = PFQuery(className: "Groups")
    query.whereKey("members", equalTo: CURRENT_USER)
    
    query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
      self.data = results! as [PFObject]
      self.tableView.reloadData()
    }
  }
  
  
  // ******************************
  // MARK: - Table View Data Source
  // ******************************
  
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 80
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.data != nil ? self.data.count : 1
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if self.data != nil && self.data.count != 0 {

      let group = self.data[indexPath.row]
      let cell = tableView.dequeueReusableCellWithIdentifier("GroupCell", forIndexPath: indexPath) as! GroupCell
      
      cell.groupnameLabel!.text = group["groupname"] as? String
      cell.groupTaglineLabel!.text = group["tagline"] as? String
      cell.numMembersLabel!.text = "(" + String(group["members"].count) + " members)"
      cell.expandButton.tag = indexPath.row
      cell.expandButton.addTarget(self, action: "joinGroup:", forControlEvents: .TouchUpInside)
      return cell
      
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier("NoGroupsCell", forIndexPath: indexPath)
      return cell
      
    }
  }
}
