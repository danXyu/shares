//
//  ProfileViewController.swift
//  Shares
//
//  Created by Dan Xiaoyu Yu on 12/1/15.
//  Copyright © 2015 Corner Innovations LLC. All rights reserved.
//


import Foundation
import UIKit
import Parse


// *****************************
// MARK: - ProfileViewController
// *****************************


class ProfileViewController : UITableViewController {
  
  
  // *****************************************
  // MARK: - Variables, Outlets, and Constants
  // *****************************************

  
  @IBOutlet var profileContainer : UIView!
  @IBOutlet var profileImageView : UIImageView!
  @IBOutlet var bgImageView : UIImageView!
  @IBOutlet var nameLabel : UILabel!
  @IBOutlet var nameFieldLabel : UILabel!
  @IBOutlet var emailLabel : UILabel!
  @IBOutlet var emailFieldLabel : UILabel!
  @IBOutlet var schoolLabel : UILabel!
  @IBOutlet var schoolFieldLabel : UILabel!
  @IBOutlet var yearLabel : UILabel!
  @IBOutlet var yearFieldLabel : UILabel!
  @IBOutlet var logoutButton : UIButton!
  
  
  // ************************************
  // MARK: - Necessary View Configuration
  // ************************************
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.separatorColor = UIColor(white: 0.85, alpha: 1.0)
    bgImageView.image = UIImage(named: "ProfileBackground")
    profileImageView.image = UIImage(named: "ProfilePicPlaceholder")
    profileImageView.layer.cornerRadius = 35
    profileImageView.clipsToBounds = true
    
    logoutButton.tintColor = UIColor(red: 0.19, green: 0.38, blue: 0.73, alpha: 1.0)
    logoutButton.addTarget(self, action: "logoutUser", forControlEvents: .TouchUpInside)
  }
  
  override func viewDidAppear(animated: Bool) {
    if let _ = CURRENT_USER.objectForKey("proPic") as? PFFile {
      getImage("proPic", imgView: profileImageView)
    }
    nameFieldLabel.text = CURRENT_USER.objectForKey("fullName") as? String
    emailFieldLabel.text = CURRENT_USER.email
    schoolFieldLabel.text = CURRENT_USER.objectForKey("school") as? String
    yearFieldLabel.text = CURRENT_USER.objectForKey("year") as? String
  }
  
  
  // ***************************************
  // MARK: - Parse Logging Out Configuration
  // ***************************************
  
  
  func logoutUser() {
    PFUser.logOut()
    self.performSegueWithIdentifier("logoutSuccess", sender: self)
  }
  
  
  // ********************************
  // MARK: - Table View Configuration
  // ********************************
  
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 6
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return indexPath.row == 0 ? 150 : 62
  }
  
  
  // ***************************
  // MARK: - Text Field Delegate
  // ***************************

  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true;
  }
}
