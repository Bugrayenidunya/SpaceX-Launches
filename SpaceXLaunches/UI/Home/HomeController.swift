//
//  HomeController.swift
//  SpaceXLaunches
//
//  Created by Bugra's Mac on 21.11.2020.
//

import Kingfisher
import UIKit

class HomeController: UIViewController {
  
  // MARK: Properties
  
  /// ViewModel init
  private let viewModel = HomeViewModel()
  /// Launches
  private var launches: [Launch] = []
  /// All Launches
  private var allLaunches: [Launch] = []
  /// Number of page
  var numberOfPage = 2
  /// Activity indicator for show to user while fetching the data from api
  let activityIndicator = UIActivityIndicatorView(style: .large)
  
  // MARK: Outlets
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var filterBarButton: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    navigationItem.title = "Launches"
    
    // Inits
    setActivityIndicator()
    loadFirstTwentyLaunches()
  }
  
  // MARK: Functions
  
  func loadFirstTwentyLaunches() {
    // When app starts, we are fetching the first 20 launches
    viewModel.fetchLaunches { (result) in
      switch result {
        case .success(let launches):
          self.allLaunches = launches
          var i = 0
          while i < 20 {
            self.launches.append(self.allLaunches[i])
            i += 1
          }
          self.activityIndicator.stopAnimating()
          self.tableView.reloadData()
        case .failure(let error):
          print(error, #line, #file)
      }
    }
  }
  
  func setActivityIndicator() {
    // Place the activity indicator on the center of your current screen
    activityIndicator.center = view.center
    
    // In most cases this will be set to true, so the indicator hides when it stops spinning
    activityIndicator.hidesWhenStopped = true
    
    // Start the activity indicator and place it onto your view
    activityIndicator.startAnimating()
    view.addSubview(activityIndicator)
  }
  
  // MARK: Actions
  
  @IBAction func filterBarButtonPressed(_ sender: UIBarButtonItem) {
    
  }
  
}

// MARK: - UITableViewDelegate

extension HomeController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    // Calculate the position of one screen length before the bottom of the results
    let scrollViewContentHeight = tableView.contentSize.height
    let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
    
    // When the user has scrolled past the threshold, start loading more
    if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
      
      if numberOfPage == 2 {
        launches.append(contentsOf: allLaunches[20...40])
        numberOfPage = 3
        tableView.reloadData()
      } else if numberOfPage == 3 {
        launches.append(contentsOf: allLaunches[41...60])
        numberOfPage = 4
        tableView.reloadData()
      } else if numberOfPage == 4 {
        launches.append(contentsOf: allLaunches[61...80])
        numberOfPage = 5
        tableView.reloadData()
      } else if numberOfPage == 5 {
        launches.append(contentsOf: allLaunches[81...])
        numberOfPage = 6
        tableView.reloadData()
      }
      
    }
  }
  
}

// MARK: - UITableViewDataSource

extension HomeController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return launches.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let launch = launches[indexPath.row]
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.UI.homeTableViewCell) as? HomeTableViewCell else { return UITableViewCell() }
    
    if let url = URL(string: (launch.links?.missionPatchSmall)!) {
      cell.missionPatchImageView.kf.indicatorType = .activity
      cell.missionPatchImageView.kf.setImage(with: url,  options: [
        .transition(.fade(1)),
        .cacheOriginalImage
      ])
    }
    
    cell.rocketNameLabel.text = launch.rocket?.rocketName
    cell.launchDateLabel.text = launch.launchYear
    
    if launch.launchSuccess != nil && launch.launchSuccess != false {
      cell.isLaunchSuccessLabel.text = "Successfully Launched 🚀"
      cell.isLaunchSuccessLabel.textColor = UIColor.systemGreen
    } else {
      cell.isLaunchSuccessLabel.text = "Launch Failed 😔"
      cell.isLaunchSuccessLabel.textColor = UIColor.red
    }
    
    return cell
  }
  
}
