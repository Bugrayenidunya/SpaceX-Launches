//
//  DetailController.swift
//  SpaceXLaunches
//
//  Created by Bugra's Mac on 21.11.2020.
//

import Kingfisher
import UIKit

class DetailController: UIViewController {
  
  // MARK: Properties
  
  /// Init viewModel
  private let viewModel = DetailViewModel()
  /// The launch from home page
  var launch: Launch?
  /// Lucnh article link
  var launchArticleLink: String = ""
  /// Launch video link
  var launchVideoLink: String = ""
  
  // MARK: Outlets
  
  @IBOutlet weak var launchImageView: UIImageView!
  @IBOutlet weak var launchDetailTextView: UITextView!
  @IBOutlet weak var launchArticleLinkButton: UIButton!
  @IBOutlet weak var launchVideoLinkButton: UIButton!
  @IBOutlet weak var launchYearLabel: UILabel!
  @IBOutlet weak var launchSuccessLabel: UILabel!
  @IBOutlet weak var launchMissionNameLabel: UILabel!
  @IBOutlet weak var linkView: UIView!
  @IBOutlet weak var seperatorLineView: UIView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    initLaunch()
    
    // Image
    if let launch = launch {
      if let links = launch.links {
        if let missionPatch = links.missionPatch {
          if let url = URL(string: (missionPatch)) {
            launchImageView.kf.indicatorType = .activity
            launchImageView.kf.setImage(with: url,  options: [
              .transition(.fade(1)),
              .cacheOriginalImage
            ])
          }
        }
      }
    }
    navigationItem.title = launch?.rocket?.rocketName
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    configureViews()
  }
  
  // MARK: Functions
  
  func configureViews() {
    linkView.backgroundColor = UIColor.systemGroupedBackground
    linkView.layer.cornerRadius = 4
    
    seperatorLineView.backgroundColor = UIColor.systemGroupedBackground
    seperatorLineView.layer.borderColor = UIColor.systemGroupedBackground.cgColor
    seperatorLineView.layer.borderWidth = 1
  }
  
  func initLaunch() {
    if let launch = launch {
      if let detail = launch.details, let articleLink = launch.links?.articleLink, let videoLink = launch.links?.videoLink, let launchYear = launch.launchYear, let missionName = launch.missionName, let launchSuccess = launch.launchSuccess {
        // Detail
        launchDetailTextView.text = detail
        // Launch Year
        launchYearLabel.text = launchYear
        // Mission Name
        if missionName.isEmpty != true {
          launchMissionNameLabel.text = missionName
        } else {
          launchMissionNameLabel.text = "Not Available"
        }
        // Article Link
          launchArticleLink = articleLink
        // Video Link
          launchVideoLink = videoLink
        // Launch Success
        if launchSuccess {
          launchSuccessLabel.text = "Successfully Launched"
          return
        }
        launchSuccessLabel.text = "Launch Failed"
      }
    }
  }
  
  func openUrl(with url: String) {
    UIApplication.shared.open(URL(string: url)!)
  }
  
  // MARK: Actions
  
  @IBAction func articleButtonPressed(_ sender: UIButton) {
    if launchArticleLink.isEmpty != true {
      openUrl(with: launchArticleLink)
      return
    }

    let alert = UIAlertController(title: "Warning", message: "Link is not available", preferredStyle: .alert)

    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in

    }))

    self.present(alert, animated: true, completion: nil)
  }
  
  @IBAction func videoButtonPressed(_ sender: UIButton) {
    if launchVideoLink.isEmpty != true {
      openUrl(with: launchVideoLink)
      return
    }

    let alert = UIAlertController(title: "Warning", message: "Link is not available", preferredStyle: .alert)

    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in

    }))

    self.present(alert, animated: true, completion: nil)
  }
  
}
