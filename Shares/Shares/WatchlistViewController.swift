//
//  FirstViewController.swift
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


// *******************************
// MARK: - WatchlistViewController
// *******************************


class WatchlistViewController: UITableViewController {
  
  
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
    loadWatchlist()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    loadWatchlist()
  }
  
  
  // **************************
  // MARK: - Parse Data Methods
  // **************************
  
  
  func loadWatchlist(){
    let query = PFQuery(className: "Stock")
    query.whereKey("watchingUsers", equalTo: CURRENT_USER)
    
    query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
      self.data = results! as [PFObject]
      self.tableView.reloadData()
    }
  }
  
  
  // ********************************
  // MARK: - Table View Configuration
  // ********************************
  
  
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
      
      let stock = self.data[indexPath.row]
      let cell = tableView.dequeueReusableCellWithIdentifier("StockCell", forIndexPath: indexPath) as! WatchlistViewCell
      cell.stockName!.text = stock["Name"] as? String
      cell.stockPrice!.text = stock["LastSale"] as? String
      
//      let url: NSURL = NSURL(string: "http://dev.markitondemand.com/MODApis/Api/v2/Quote/jsonp?symbol=" + String(stock["Symbol"]))!
//      let sessionRequest = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
//        print(NSString(data: data!, encoding: NSUTF8StringEncoding))
//      }
//      sessionRequest.resume()
      
      return cell
      
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier("NoStocksCell", forIndexPath: indexPath)
      return cell
    }
  }
}
