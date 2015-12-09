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


// ******************************
// MARK: - NewGroupViewController
// ******************************


class NewGroupViewController: UITableViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate {

  
  // *****************************************
  // MARK: - Variables, Outlets, and Constants
  // *****************************************
  
  
  @IBOutlet weak var groupnameTextField: UITextField!
  @IBOutlet weak var taglineTextField: UITextField!
  @IBOutlet weak var industryLabel: UILabel!
  @IBOutlet weak var passwordTextField: UITextField!
  
  var industries: NSArray =  NSArray()
  var picker = UIPickerView()
  var actionSheet: UIView = UIView()
  
  
  // ***************************************************
  // MARK: - General View and Notification Configuration
  // ***************************************************
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.separatorColor = UIColor(white: 0.75, alpha: 1.0)
    
    if let checkWindow: UIWindow = UIApplication.sharedApplication().keyWindow {
      WINDOW = checkWindow
    }
    
    picker.backgroundColor = UIColor.whiteColor()
    actionSheet.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 300.0)
    
    industries = ["Energy", "Materials", "Industrials", "Consumer Discretionary", "Consumer Staples", "Health Care", "Financials", "Information Technology", "Telecommunication Services", "Utilities"];
  }
  
  
  // ****************************************
  // MARK: - Parse Group Saving Configuration
  // ****************************************
  
  
  @IBAction func cancelTapped(sender: AnyObject) {
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  @IBAction func saveTapped(sender: AnyObject) {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    
    if (groupnameTextField.text!.isEmpty || taglineTextField.text!.isEmpty) {
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      
      let alertController = UIAlertController(
        title: "Form Field Error",
        message: "Group name and group tagline cannot be empty.",
        preferredStyle: .Alert
      )
      
      alertController.addAction(UIAlertAction(
        title: "Try Again",
        style: .Default,
        handler: nil
      ))
      self.presentViewController(alertController, animated: true, completion: nil)
      
    } else {
      
      let group = PFObject(className: "Groups")
      group["groupname"] = groupnameTextField.text
      group["tagline"] = taglineTextField.text
      group["industry"] = industryLabel.text
      group["password"] = passwordTextField.text
      group["members"] = [CURRENT_USER]
      
      group.saveInBackgroundWithBlock() { (success, error) -> Void in
        if error == nil {
          MBProgressHUD.hideHUDForView(self.view, animated: true)
          
          let alertController = UIAlertController(
            title: "Success",
            message: "Group successfully created! Click to manage your group.",
            preferredStyle: .Alert
          )
          
          alertController.addAction(UIAlertAction(
            title: "Continue",
            style: .Default,
            handler: nil
          ))
          self.presentViewController(alertController, animated: true, completion: nil)
          self.navigationController?.popViewControllerAnimated(true)
          
        } else {
          
          MBProgressHUD.hideHUDForView(self.view, animated: true)
          
          if let errorString = error!.userInfo["error"] as? NSString {
            
            let alertController = UIAlertController(
              title: "Error",
              message: errorString as String,
              preferredStyle: .Alert
            )
            
            alertController.addAction(UIAlertAction(
              title: "Okay",
              style: .Default,
              handler: nil
              ))
            self.presentViewController(alertController, animated: true, completion: nil)
          }
        }
      }
    }
  }
  
  
  // ***********************************
  // MARK: - Custom Picker Configuration
  // ***********************************
  
  
  /*
  *  Function: executeIndustryPicker(sender)
  *  ---------------------------------------
  *  Alternative to picker view that looks nicer. Instead of having a picker view in a table view 
  *  cell, allow a custom picker view to move onto the screen, allowing the user to select industry.
  */
  @IBAction func executeIndustryPicker(sender: UIButton) {
    picker.frame = CGRectMake(0.0, 44.0, PHONE_WIDTH, 220.0)
    picker.dataSource = self
    picker.delegate = self
    picker.backgroundColor = UIColor.whiteColor()
    
    let pickerBar = UIToolbar(frame: CGRectMake(0, 0, PHONE_WIDTH, 44.0))
    pickerBar.barTintColor = BACKGROUND_COLOR
    
    var barItems = [UIBarButtonItem]()
    
    let titleCancel = UIBarButtonItem(
      title: "Cancel",
      style: UIBarButtonItemStyle.Plain,
      target: self,
      action: Selector("cancelIndustrySelection:")
    )
    
    let flexSpace = UIBarButtonItem(
      barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace,
      target: self,
      action: nil
    )

    let doneBtn = UIBarButtonItem(
      title: "Change Industry",
      style: UIBarButtonItemStyle.Plain,
      target: self,
      action: Selector("changeIndustrySelection:")
    )
    
    barItems.append(titleCancel)
    barItems.append(flexSpace)
    barItems.append(doneBtn)
    pickerBar.setItems(barItems as [UIBarButtonItem], animated: true)
    
    actionSheet.addSubview(pickerBar)
    actionSheet.addSubview(picker)
    
    if (WINDOW != nil) {
      WINDOW!.addSubview(actionSheet)
    }
    
    UIView.animateWithDuration(0.5, animations: {
      self.actionSheet.frame = CGRectMake(
        0, UIScreen.mainScreen().bounds.size.height - 300.0,
        UIScreen.mainScreen().bounds.size.width, 300.0
      )
    })
  }
  
  
  /*
  *  Function: cancelIndustrySelection(sender)
  *  -----------------------------------------
  *  Remove the custom picker uiview from the screen by animating it to an offscreen position.
  */
  func cancelIndustrySelection(sender: UIBarButtonItem) {
    UIView.animateWithDuration(0.5, animations: {
      
      self.actionSheet.frame = CGRectMake(
        0, UIScreen.mainScreen().bounds.size.height,
        UIScreen.mainScreen().bounds.size.width, 300.0
      );
      
      }, completion: { _ in
        for subview in self.actionSheet.subviews {
          subview.removeFromSuperview()
        }
      }
    )
  }
  
  
  /*
  *  Function: changeIndustrySelection(sender)
  *  -----------------------------------------
  *  Gets selected row of uipickerview and set industry to its text. Then remove picker view.
  */
  func changeIndustrySelection(sender: UIBarButtonItem) {
    let selectedRow = picker.selectedRowInComponent(0)
    industryLabel.text = industries[selectedRow] as? String
    
    UIView.animateWithDuration(0.5, animations: {
      
      self.actionSheet.frame = CGRectMake(
        0, UIScreen.mainScreen().bounds.size.height,
        UIScreen.mainScreen().bounds.size.width, 300.0
      )
      
      }, completion: { _ in
        for subview in self.actionSheet.subviews {
          subview.removeFromSuperview()
        }
      }
    )
  }
  
  
  // *********************************
  // MARK: - Picker View Configuration
  // *********************************
  
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return industries.count
  }
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return industries.objectAtIndex(row) as! NSString as String
  }

  
  // ********************************
  // MARK: - Table View Configuration
  // ********************************
  
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return indexPath.row == 0 ? 120 : 80
  }
  
  
  // **********************************
  // MARK: - Text Handler Configuration
  // **********************************
  

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
