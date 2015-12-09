//
//  SearchStockViewController.swift
//  Shares
//
//  Created by Dan Xiaoyu Yu on 12/8/15.
//  Copyright © 2015 Corner Innovations LLC. All rights reserved.
//


import Foundation
import UIKit
import Parse
import MBProgressHUD


// *********************************
// MARK: - SearchStockViewController
// *********************************


class SearchStockViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
  
  
  // *****************************************
  // MARK: - Variables, Outlets, and Constants
  // *****************************************
  
  
  @IBOutlet weak var tableView: UITableView!
  var searchActive: Bool = false
  var data: [PFObject]!
  
  
  // *************************************
  // MARK: - View Controller Configuration
  // *************************************
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    search()
  }

  
  // **************************
  // MARK: - Parse Data Methods
  // **************************
  
  
  func addStock(sender: UIButton) {
    let stock = self.data[sender.tag]
    stock.addUniqueObject(CURRENT_USER, forKey: "watchingUsers")
    
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    
    stock.saveInBackgroundWithBlock() { (success, error) -> Void in
      if error == nil {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        
        let alertController = UIAlertController(
          title: "Success",
          message: "You have successfully added this stock. Please check your watchlist.",
          preferredStyle: .Alert
        )
        
        alertController.addAction(UIAlertAction(
          title: "Continue",
          style: .Default,
          handler: nil
          ))
        self.presentViewController(alertController, animated: true, completion: nil)
        
        self.performSegueWithIdentifier("stockAddedSuccess", sender: self)
        
      } else {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        if let errorString = error!.userInfo["error"] as? NSString {
          
          let alertController = UIAlertController(
            title: "Error",
            message: errorString as String,
            preferredStyle: .Alert
          )
          
          alertController.addAction(UIAlertAction(
            title: "Continue",
            style: .Default,
            handler: nil
            ))
          self.presentViewController(alertController, animated: true, completion: nil)
        }
      }
    }
  }
  
  
  // ****************************
  // MARK: - Search Configuration
  // ****************************
  
  
  func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
    searchActive = true;
  }
  
  func searchBarTextDidEndEditing(searchBar: UISearchBar) {
    searchActive = false;
  }
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    searchActive = false;
  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchActive = false;
  }
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    search(searchText)
  }
  
  func search(searchText: String? = nil){
    let query = PFQuery(className: "Stock")
    if (searchText != nil) {
      query.whereKey("name", containsString: searchText)
    }
    query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
      self.data = results! as [PFObject]
      self.tableView.reloadData()
    }
  }
  
  
  // ********************************
  // MARK: - Table View Configuration
  // ********************************
  
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 80
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.data != nil ? self.data.count : 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if self.data != nil && self.data.count != 0 {
      
      let stock = self.data[indexPath.row]
      let cell = tableView.dequeueReusableCellWithIdentifier("SearchStockCell", forIndexPath: indexPath) as! SearchStockCell
      cell.stockName!.text = stock["Name"] as? String
      cell.addButton.addTarget(self, action: "addStock:", forControlEvents: .TouchUpInside)
      return cell
      
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier("SearchNoneCell", forIndexPath: indexPath)
      return cell
    }
  }
}
