//
//  GroupCell.swift
//  Shares
//
//  Created by Dan Xiaoyu Yu on 12/8/15.
//  Copyright © 2015 Corner Innovations LLC. All rights reserved.
//


import Foundation
import UIKit
import Parse


// *****************
// MARK: - GroupCell
// *****************


class GroupCell: UITableViewCell {
  
  
  // *****************************************
  // MARK: - Variables, Outlets, and Constants
  // *****************************************
  
  
  @IBOutlet weak var groupnameLabel: UILabel!
  @IBOutlet weak var groupTaglineLabel: UILabel!
  @IBOutlet weak var numMembersLabel: UILabel!
  @IBOutlet weak var expandButton: UIButton!
  
  
  // *****************************************
  // MARK: - Standard Table Cell Configuration
  // *****************************************
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
