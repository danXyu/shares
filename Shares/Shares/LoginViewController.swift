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
    
    titleLabel.text = "Tend"
    titleLabel.textColor = UIColor.whiteColor()
    
    let attributedText = NSMutableAttributedString(string: "Don't have an account? Sign up")
    attributedText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(23, 7))
    attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange(0, attributedText.length))
    noAccountButton.setAttributedTitle(attributedText, forState: .Normal)
    noAccountButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    
    forgotPassword.setTitle("Forgot Password?", forState: .Normal)
    forgotPassword.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    
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
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
  
  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    return true
  }
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    //    textField.resignFirstResponder()
    self.view.endEditing(true)
    return false
  }
  
  // ***************************
  // MARK: - Parse Login Methods
  // ***************************
//  
//  func loginNormal() {
//    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//    var newUsername = userTextField.text
//    var newPassword = passwordTextField.text
//    
//    PFUser.logInWithUsernameInBackground(newUsername, password: newPassword, block: { (newUser: PFUser?, newError: NSError?) -> Void in
//      if newUser != nil {
//        currentUser = newUser!
//        if UIDevice.currentDevice().model != "iPhone Simulator" {
//          let currentInstallation = PFInstallation.currentInstallation()
//          currentInstallation["user"] = currentUser
//          currentInstallation.saveInBackground()
//        }
//        self.performSegueWithIdentifier("loginSuccess", sender: self)
//        MBProgressHUD.hideHUDForView(self.view, animated: true)
//      } else {
//        MBProgressHUD.hideHUDForView(self.view, animated: true)
//        
//        if let errorString = newError!.userInfo?["error"] as? NSString {
//          var alert = UIAlertView(title: "Error", message: errorString as String, delegate: self, cancelButtonTitle: "okay")
//          alert.show()
//        }
//      }
//      
//    })
//  }
//  
//  func loginFacebook() {
//    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//    
//    var permissions = ["public_profile", "email", "user_friends"]
//    PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) { (user: PFUser?, error: NSError?) -> Void in
//      if let user = user {
//        if user.isNew {
//          NSLog("User signed up and logged in through Facebook!")
//          hasSignedUp = true
//          currentUser = user
//          self.createFacebookUser()
//        } else {
//          NSLog("User logged in through Facebook!")
//          currentUser = user
//          if UIDevice.currentDevice().model != "iPhone Simulator" {
//            let currentInstallation = PFInstallation.currentInstallation()
//            currentInstallation["user"] = currentUser
//            currentInstallation.saveInBackground()
//          }
//          MBProgressHUD.hideHUDForView(self.view, animated: true)
//          self.performSegueWithIdentifier("loginSuccess", sender: self)
//        }
//      } else {
//        NSLog("Something went wrong. User cancelled facebook Login")
//        MBProgressHUD.hideHUDForView(self.view, animated: true)
//      }
//    }
//  }
//  
//  func createFacebookUser() {
//    FBRequestConnection.startWithGraphPath("me", completionHandler: { (connection, user, fbError) -> Void in
//      if let userEmail = user.objectForKey("email") as? String {currentUser.email = userEmail}
//      var id = user.objectID as String
//      var url = NSURL(string: "https://graph.facebook.com/\(id)/picture?width=640&height=640")!
//      var data = NSData(contentsOfURL: url)
//      var image = UIImage(data: data!)
//      var imageS = scaleImage(image!, 60)
//      var dataS = UIImageJPEGRepresentation(imageS, 0.9)
//      
//      currentUser["fbId"] = user.objectID as String!
//      currentUser["proPic"] = PFFile(name: "proPic.jpg", data: dataS)
//      currentUser["fullName"] = user.name
//      currentUser["firstName"] = user.first_name as String!
//      currentUser["lastName"] = user.last_name as String!
//      currentUser["school"] = "Generic High School"
//      currentUser["year"] = "Year Placeholder"
//      
//      currentUser.saveInBackgroundWithBlock({ (done, error) -> Void in
//        if error == nil {
//          if UIDevice.currentDevice().model != "iPhone Simulator" {
//            let currentInstallation = PFInstallation.currentInstallation()
//            currentInstallation["user"] = currentUser
//            currentInstallation.saveInBackground()
//          }
//          MBProgressHUD.hideHUDForView(self.view, animated: true)
//          self.performSegueWithIdentifier("loginSuccess", sender: self)
//        } else {
//          println(error)
//          MBProgressHUD.hideHUDForView(self.view, animated: true)
//        }
//      })
//    })
//  }
}
