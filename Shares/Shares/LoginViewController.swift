//
//  LoginViewController.swift
//  Shares
//
//  Created by Dan Xiaoyu Yu on 11/30/15.
//  Copyright © 2015 Corner Innovations LLC. All rights reserved.
//


import Foundation
import UIKit
import MBProgressHUD
import FBSDKCoreKit
import FBSDKLoginKit
import Parse
import ParseFacebookUtilsV4


// ***************************
// MARK: - LoginViewController
// ***************************


class LoginViewController: UIViewController , UITextFieldDelegate{
  
  
  // *****************************************
  // MARK: - Variables, Outlets, and Constants
  // *****************************************
  
  
  @IBOutlet var titleLabel : UILabel!
  @IBOutlet var bgImageView : UIImageView!
  
  @IBOutlet var userContainer : UIView!
  @IBOutlet var userTextField : UITextField!
  
  @IBOutlet var passwordContainer : UIView!
  @IBOutlet var passwordTextField : UITextField!
  
  @IBOutlet var forgotPassword : UIButton!
  @IBOutlet var noAccountButton : UIButton!
  @IBOutlet var signInButton : UIButton!
  @IBOutlet var facebookButton : UIButton!
  
  
  // *************************************
  // MARK: - View Controller Configuration
  // *************************************
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.passwordTextField.delegate = self
    self.userTextField.delegate = self
    
    bgImageView.image = UIImage(named: "LoginBackground")
    bgImageView.contentMode = .ScaleAspectFill
    
    let attributedText = NSMutableAttributedString(string: "Don't have an account? Sign up")
    attributedText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(23, 7))
    attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange(0, attributedText.length))
    noAccountButton.setAttributedTitle(attributedText, forState: .Normal)
    
    userContainer.backgroundColor = UIColor.clearColor()
    userTextField.text = ""
    userTextField.textColor = UIColor.whiteColor()
    
    passwordContainer.backgroundColor = UIColor.clearColor()
    passwordTextField.text = ""
    passwordTextField.textColor = UIColor.whiteColor()
    passwordTextField.secureTextEntry = true
    
    signInButton.layer.borderWidth = 3
    signInButton.layer.borderColor = UIColor.whiteColor().CGColor
    signInButton.layer.cornerRadius = 5
    signInButton.addTarget(self, action: "loginNormal", forControlEvents: .TouchUpInside)
    
    facebookButton.backgroundColor = UIColor(red: 0.21, green: 0.30, blue: 0.55, alpha: 1.0)
    facebookButton.addTarget(self, action: "loginFacebook", forControlEvents: .TouchUpInside)
  }
  
  override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    titleLabel.hidden = newCollection.verticalSizeClass == UIUserInterfaceSizeClass.Compact
  }

  
  // ***************************
  // MARK: - Parse Login Methods
  // ***************************
  
  
  func loginNormal() {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    let newUsername = userTextField.text!
    let newPassword = passwordTextField.text!
    
    PFUser.logInWithUsernameInBackground(newUsername, password: newPassword, block: { (newUser: PFUser?, newError: NSError?) -> Void in
      if newUser != nil {
        CURRENT_USER = newUser!
        if UIDevice.currentDevice().model != "iPhone Simulator" {
          let currentInstallation = PFInstallation.currentInstallation()
          currentInstallation["user"] = CURRENT_USER
          currentInstallation.saveInBackground()
        }
        self.performSegueWithIdentifier("loginSuccess", sender: self)
        MBProgressHUD.hideHUDForView(self.view, animated: true)
      } else {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        
        if let errorString = newError!.userInfo["error"] as? NSString {
          let alertController = UIAlertController(
            title: "Error",
            message: errorString as String,
            preferredStyle: .Alert
          )
          
          alertController.addAction(UIAlertAction(
            title: "Try Again",
            style: .Default,
            handler: nil
            ))
          self.presentViewController(alertController, animated: true, completion: nil)
        }
      }
      
    })
  }
  
  
  func loginFacebook() {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    
    let permissions = ["public_profile", "email", "user_friends"]
    PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) { (user: PFUser?, error: NSError?) -> Void in
      if let user = user {
        if user.isNew {
          NSLog("User signed up and logged in through Facebook!")
          HAS_SIGNED_UP = true
          CURRENT_USER = user
          self.createFacebookUser()
        } else {
          NSLog("User logged in through Facebook!")
          CURRENT_USER = user
          if UIDevice.currentDevice().model != "iPhone Simulator" {
            let currentInstallation = PFInstallation.currentInstallation()
            currentInstallation["user"] = CURRENT_USER
            currentInstallation.saveInBackground()
          }
          MBProgressHUD.hideHUDForView(self.view, animated: true)
          self.performSegueWithIdentifier("loginSuccess", sender: self)
        }
      } else {
        NSLog("Something went wrong. User cancelled facebook Login")
        MBProgressHUD.hideHUDForView(self.view, animated: true)
      }
    }
  }
  
  
  func createFacebookUser() {
    FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields": ["public_profile", "picture", "email"]]).startWithCompletionHandler( { (connection, user, error) -> Void in
      
      if let userEmail = user.objectForKey("email") as? String {
        CURRENT_USER.email = userEmail
      }
      
      let id = user["objectID"] as! String
      let url = NSURL(string: "https://graph.facebook.com/\(id)/picture?width=640&height=640")!
      let data = NSData(contentsOfURL: url)
      let image = UIImage(data: data!)
      let imageS = scaleImage(image!, newSize: 60)
      let dataS = UIImageJPEGRepresentation(imageS, 0.9)
      
      CURRENT_USER["fbId"] = id
      CURRENT_USER["proPic"] = PFFile(name: "propic.jpg", data: dataS!)
      CURRENT_USER["fullName"] = user["name"] as! String
      CURRENT_USER["investingStrat"] = "Value Investing"
      CURRENT_USER["netWorth"] = "No net worth"
      
      CURRENT_USER.saveInBackgroundWithBlock({ (done, error) -> Void in
        if error == nil {
          if UIDevice.currentDevice().model != "iPhone Simulator" {
            let currentInstallation = PFInstallation.currentInstallation()
            currentInstallation["user"] = CURRENT_USER
            currentInstallation.saveInBackground()
          }
          MBProgressHUD.hideHUDForView(self.view, animated: true)
          self.performSegueWithIdentifier("loginSuccess", sender: self)
        } else {
          print(error)
          MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
      })
    })
  }
  
  
  // ***************************
  // MARK: - Text Field Delegate
  // ***************************
  
  
  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    return true
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return false
  }
}
