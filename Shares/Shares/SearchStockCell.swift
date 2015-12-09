//
//  SearchStockCell.swift
//  Shares
//
//  Created by Dan Xiaoyu Yu on 12/8/15.
//  Copyright © 2015 Corner Innovations LLC. All rights reserved.
//


import Foundation
import UIKit
import Parse


// ***********************
// MARK: - SearchStockCell
// ***********************


class SearchStockCell: UITableViewCell {
  
  
  // *****************************************
  // MARK: - Variables, Outlets, and Constants
  // *****************************************
  
  
  @IBOutlet weak var stockName: UILabel!
  @IBOutlet weak var addButton: UIButton!
  
  // *****************************************
  // MARK: - Standard Table Cell Configuration
  // *****************************************
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
}

