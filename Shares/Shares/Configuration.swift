//
//  Configuration.swift
//  Shares
//
//  Created by Dan Xiaoyu Yu on 11/30/15.
//  Copyright © 2015 Corner Innovations LLC. All rights reserved.
//


import Foundation
import UIKit
import Parse


//  ***************
//  Device Settings
//  ***************

let iOSVERION = NSString(string: DEVICE.systemVersion).doubleValue
let iOS8 = (iOSVERION >= 8)
let iOS7 = (iOSVERION >= 7 && iOSVERION < 8)
let DEVICE = UIDevice.currentDevice()
let PHONE_WIDTH = UIScreen.mainScreen().bounds.width
let PHONE_HEIGHT = UIScreen.mainScreen().bounds.height
let MAINBOARD = UIStoryboard(name: "Main", bundle: nil)
var NAVBAR_HEIGHT:CGFloat = 64
var TABBAR_HEIGHT:CGFloat = 49


//  *******************
//  Parse Configuration
//  *******************

var PARSE_APP_ID = "U7VILKaweI7qrSQWuHNqcdMTL9Jjb6GtiPJPVjCA"
var PARSE_APP_SECRET = "D4mNycrbm5zNyol2K57Kdl146BG4mW55vHKzSQds"


//  *******************
//  Parse User Settings
//  *******************

let PARSE_USER = PFUser()
var CURRENT_USER = PFUser.currentUser()!
var HAS_SIGNED_UP = false
var descriptionSeed = "Hello. I'm currently a student and I just signed up for Tend."

