//
//  SignupViewController.swift
//  Shares
//
//  Created by Dan Xiaoyu Yu on 11/30/15.
//  Copyright © 2015 Corner Innovations LLC. All rights reserved.
//


import Foundation
import UIKit
import MBProgressHUD
import ParseFacebookUtilsV4


// ***************************
// MARK: - LoginViewController
// ***************************


class SignupViewController: UIViewController, UITextFieldDelegate {
  
  
  // *****************************************
  // MARK: - Variables, Outlets, and Constants
  // *****************************************
  
  
  @IBOutlet var bgImageView : UIImageView!
  @IBOutlet var titleLabel : UILabel!
  
  @IBOutlet var fullNameContainer : UIView!
  @IBOutlet var fullNameLabel : UILabel!
  @IBOutlet var fullNameTextField : UITextField!
  @IBOutlet var fullNameUnderline : UIView!
  
  @IBOutlet var userContainer : UIView!
  @IBOutlet var userLabel : UILabel!
  @IBOutlet var userTextField : UITextField!
  @IBOutlet var userUnderline : UIView!
  
  @IBOutlet var passwordContainer : UIView!
  @IBOutlet var passwordLabel : UILabel!
  @IBOutlet var passwordTextField : UITextField!
  @IBOutlet var passwordUnderline : UIView!
  
  @IBOutlet var passwordConfirmContainer : UIView!
  @IBOutlet var passwordConfirmLabel : UILabel!
  @IBOutlet var passwordConfirmTextField : UITextField!
  @IBOutlet var passwordConfirmUnderline : UIView!
  
  @IBOutlet var hasAccountButton : UIButton!
  @IBOutlet var signUpButton : UIButton!
  @IBOutlet var facebookButton : UIButton!
  
  var alertError: NSString!
  var hasSignedUp = false
  
  
  // *************************************
  // MARK: - View Controller Configuration
  // *************************************
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.fullNameTextField.delegate = self
    self.userTextField.delegate = self
    self.passwordConfirmTextField.delegate = self
    self.passwordTextField.delegate = self
    
    bgImageView.image = UIImage(named: "SignupBackground")
    bgImageView.contentMode = .ScaleAspectFill
    
    titleLabel.font = UIFont(name: DEFAULT_FONT, size: 50)
    titleLabel.textColor = UIColor.whiteColor()
    
    if (PHONE_HEIGHT >= 667) {
      titleLabel.text = "Registration"
    } else {
      titleLabel.text = ""
    }
    
    let attributedText = NSMutableAttributedString(string: "Already have an account? Sign In")
    attributedText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(25, 7))
    attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange(0, attributedText.length))
    hasAccountButton.setAttributedTitle(attributedText, forState: .Normal)
    hasAccountButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    hasAccountButton.titleLabel?.font = UIFont(name: DEFAULT_FONT, size: 12)
    
    fullNameContainer.backgroundColor = UIColor.clearColor()
    fullNameLabel.text = "Full Name"
    fullNameLabel.textColor = UIColor.whiteColor()
    fullNameLabel.font = UIFont(name: DEFAULT_FONT, size: 18)
    fullNameTextField.text = ""
    fullNameTextField.textColor = UIColor.whiteColor()
    fullNameTextField.font = UIFont(name: DEFAULT_FONT, size: 18)
    
    userContainer.backgroundColor = UIColor.clearColor()
    userLabel.text = "Email"
    userLabel.textColor = UIColor.whiteColor()
    userLabel.font = UIFont(name: DEFAULT_FONT, size: 18)
    userTextField.text = ""
    userTextField.textColor = UIColor.whiteColor()
    userTextField.font = UIFont(name: DEFAULT_FONT, size: 18)
    
    passwordContainer.backgroundColor = UIColor.clearColor()
    passwordLabel.text = "Password"
    passwordLabel.textColor = UIColor.whiteColor()
    passwordLabel.font = UIFont(name: DEFAULT_FONT, size: 18)
    passwordTextField.text = ""
    passwordTextField.textColor = UIColor.whiteColor()
    passwordTextField.font = UIFont(name: DEFAULT_FONT, size: 18)
    passwordTextField.secureTextEntry = true
    
    passwordConfirmContainer.backgroundColor = UIColor.clearColor()
    passwordConfirmLabel.text = "Confirm Password"
    passwordConfirmLabel.textColor = UIColor.whiteColor()
    passwordConfirmLabel.font = UIFont(name: DEFAULT_FONT, size: 18)
    passwordConfirmTextField.text = ""
    passwordConfirmTextField.textColor = UIColor.whiteColor()
    passwordConfirmTextField.font = UIFont(name: DEFAULT_FONT, size: 18)
    passwordConfirmTextField.secureTextEntry = true
    
    signUpButton.setTitle("Sign Up", forState: .Normal)
    signUpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    signUpButton.titleLabel?.font = UIFont(name: DEFAULT_FONT, size: 22)
    signUpButton.layer.borderWidth = 3
    signUpButton.layer.borderColor = UIColor.whiteColor().CGColor
    signUpButton.layer.cornerRadius = 5
    signUpButton.addTarget(self, action: "registerNormal", forControlEvents: .TouchUpInside)
    
    facebookButton.setTitle("Sign Up with Facebook", forState: .Normal)
    facebookButton.titleLabel?.font = UIFont(name: DEFAULT_FONT, size: 16)
    facebookButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    facebookButton.backgroundColor = UIColor(red: 0.21, green: 0.30, blue: 0.55, alpha: 1.0)
    facebookButton.addTarget(self, action: "registerFacebook", forControlEvents: .TouchUpInside)
  }
  
  
  // ****************************
  // MARK: - Parse Signup Methods
  // ****************************
  
  
  func registerNormal() {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    if self.checkNormalSignup() == true {
      self.createNormalUser()
    } else {
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      
      let alertController = UIAlertController(
        title: "Form Field Error",
        message: alertError as String,
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
  
  func checkNormalSignup()-> Bool {
    return true
  }
  
  func createNormalUser() {
    CURRENT_USER.username = userTextField.text
    CURRENT_USER.email = userTextField.text
    CURRENT_USER.password = passwordTextField.text
    
    CURRENT_USER.signUpInBackgroundWithBlock {(succeeded, error) -> Void in
      if error == nil {
        self.hasSignedUp = true
        if UIDevice.currentDevice().model != "iPhone Simulator" {
          let currentInstallation = PFInstallation.currentInstallation()
          currentInstallation["user"] = CURRENT_USER
          currentInstallation.saveInBackground()
        }
        self.performSegueWithIdentifier("signupSuccess", sender: self)
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        
        let alertController = UIAlertController(
          title: "Sign Up Success",
          message: "Sign up successful. Please confirm your email",
          preferredStyle: .Alert
        )
        
        alertController.addAction(UIAlertAction(
          title: "Continue",
          style: .Default,
          handler: nil
          ))
        self.presentViewController(alertController, animated: true, completion: nil)
      } else {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        if let errorString = error!.userInfo["error"] as? NSString {
          var alert = UIAlertView(title: "Sign Up Error", message: errorString as String, delegate: self, cancelButtonTitle: "Try Again")
          alert.show()
        }
        
      }
    }
  }
  
  
  func registerFacebook() {
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
    textField.resignFirstResponder()
    return true
  }
}
