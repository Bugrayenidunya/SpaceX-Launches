//
//  HomeTableViewCell.swift
//  SpaceXLaunches
//
//  Created by Bugra's Mac on 21.11.2020.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
  
  // MARK: Outlets
  
  @IBOutlet weak var missionPatchImageView: UIImageView!
  @IBOutlet weak var rocketNameLabel: UILabel!
  @IBOutlet weak var launchDateLabel: UILabel!
  @IBOutlet weak var isLaunchSuccessLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
