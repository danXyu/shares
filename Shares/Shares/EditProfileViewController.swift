//
//  EditProfileViewController.swift
//  Shares
//
//  Created by Dan Xiaoyu Yu on 12/1/15.
//  Copyright © 2015 Corner Innovations LLC. All rights reserved.
//


import Foundation
import UIKit
import Parse
import MBProgressHUD


// *********************************
// MARK: - EditProfileViewController
// *********************************

class EditProfileViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
  
  @IBOutlet var profileContainer: UIView!
  @IBOutlet var profileImageView: UIImageView!
  @IBOutlet var bgImageView: UIImageView!
  
  @IBOutlet var nameTextField: UITextField!
  @IBOutlet var emailFieldLabel: UILabel!
  @IBOutlet weak var strategyPicker: UIPickerView!
  @IBOutlet weak var netWorthField: UITextField!
  
  var buttonclicked: Int!
  var profileImageChanged: Bool = false
  var investingStrategies: [String] = [String]()
  
  
  // ************************************
  // MARK: - Necessary View Configuration
  // ************************************
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.separatorColor = UIColor(white: 0.75, alpha: 1.0)
    bgImageView.image = UIImage(named: "ProfileBackground")
    profileImageView.image = UIImage(named: "ProfilePicPlaceholder")
    profileImageView.layer.cornerRadius = 35
    profileImageView.clipsToBounds = true
    
    self.strategyPicker.delegate = self
    self.strategyPicker.dataSource = self
    
    investingStrategies = ["Value Investing", "Momentum Investing", "Day Trading", "Technical Investing"]
  }
  
  override func viewDidAppear(animated: Bool) {
    if let _ = CURRENT_USER.objectForKey("proPic") as? PFFile {
      getImage("proPic", imgView: profileImageView)
    }
    nameTextField.text = CURRENT_USER.objectForKey("fullName") as? String
    emailFieldLabel.text = CURRENT_USER.email
    netWorthField.text = CURRENT_USER.objectForKey("netWorth") as? String
  }
  
  
  // The profile picture isn't loading for some reason, but clicking in center of white 
  // space opens up the UIImagePickerController
  
  @IBAction func profilePicTapped(sender: AnyObject) {
    let mediapicker = UIImagePickerController()
    mediapicker.allowsEditing = true
    mediapicker.delegate = self
    mediapicker.sourceType = .PhotoLibrary
    self.presentViewController(mediapicker, animated: true, completion: nil)
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    let pickedImg = info[UIImagePickerControllerEditedImage] as! UIImage
    profileImageChanged = true
    profileImageView.image = pickedImg
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  
  // ********************************
  // MARK: - Parse User Configuration
  // ********************************
  
  
  @IBAction func cancelTapped(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func saveTapped(sender: AnyObject) {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    
    if nameTextField.text!.isEmpty || netWorthField.text!.isEmpty {
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      
      let alertController = UIAlertController(
        title: "Form Field Error",
        message: "Full name and net worth cannot be empty",
        preferredStyle: .Alert
      )
      
      alertController.addAction(UIAlertAction(
        title: "Try Again",
        style: .Default,
        handler: nil
        ))
      self.presentViewController(alertController, animated: true, completion: nil)
      
    } else {
      CURRENT_USER["fullName"] = nameTextField.text
      CURRENT_USER["investingStrat"] = investingStrategies[strategyPicker.selectedRowInComponent(0)]
      CURRENT_USER["netWorth"] = netWorthField.text
      
      if profileImageChanged == true {
        let imageSmall = scaleImage(self.profileImageView.image!, newSize: 60)
        let dataS = UIImageJPEGRepresentation(imageSmall, 0.7)
        CURRENT_USER["proPic"] = PFFile(name: "image.jpg", data: dataS!)
        CURRENT_USER.saveInBackground()
      }
      
      CURRENT_USER.saveInBackgroundWithBlock() { (done, error) -> Void in
        if error == nil {
          self.dismissViewControllerAnimated(true, completion: nil)
          MBProgressHUD.hideHUDForView(self.view, animated: true)
        } else {
          MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
      }
    }
  }
  
  
  // ********************************
  // MARK: - Table View Configuration
  // ********************************
  
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return indexPath.row == 0 ? 150 : 60
  }
  
  
  // *********************************
  // MARK: - Picker View Configuration
  // *********************************
  
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return investingStrategies.count
  }
  
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return investingStrategies[row]
  }
  
  
  // ***************************
  // MARK: - Text Field Delegate
  // ***************************
  
  
  func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    let textlength = (textView.text as NSString).length + (text as NSString).length - range.length
    if text == "\n" {
      textView.resignFirstResponder()
    }
    return (textlength > 150) ? false : true
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true;
  }
}