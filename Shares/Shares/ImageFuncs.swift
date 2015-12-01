//
//  ImageFuncs.swift
//  Shares
//
//  Created by Dan Xiaoyu Yu on 11/30/15.
//  Copyright © 2015 Corner Innovations LLC. All rights reserved.
//


import Foundation
import UIKit
import Parse


/* Helper Function: scaleImage(image, newSize) */
func scaleImage(image:UIImage, newSize:CGFloat) -> UIImage {
  UIGraphicsBeginImageContextWithOptions(CGSize(width: newSize, height: newSize), false, 0.0)
  image.drawInRect(CGRectMake(0, 0, newSize, newSize))
  let newImage = UIGraphicsGetImageFromCurrentImageContext()
  return newImage
}

/* Helper Function: getImage(forKey, imgView) */
func getImage(forKey:String, imgView:UIImageView) {
  if let pic = CURRENT_USER.objectForKey(forKey) as? PFFile {
    pic.getDataInBackgroundWithBlock({ (data:NSData?, error:NSError?) -> Void in
      if error == nil {
        imgView.image = UIImage(data: data!)
      }
    })
  }
}