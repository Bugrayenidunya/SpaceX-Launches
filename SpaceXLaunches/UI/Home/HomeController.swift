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
  /// PickerView init
  let pickerView = UIPickerView()
  /// PickerView datas from api
  var pickerViewData: [String] = []
  /// For showing the PickerView
  let hiddenTextField = UITextField()
  /// Copy every time launches loaded, for filtering purpose
  var copyOfLaunches: [Launch] = []
  /// Flag for is filtering currently
  var isFilterOn: Bool = false
  
  
  // MARK: Outlets
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var filterBarButton: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    pickerView.delegate = self
    pickerView.dataSource = self
    
    self.view.addSubview(hiddenTextField)
    hiddenTextField.isHidden = true
    hiddenTextField.inputView = pickerView
    
    filterBarButton.isEnabled = false
    
    navigationItem.title = "Launches"
    navigationController?.navigationBar.prefersLargeTitles  = true
    
    // Inits
    setActivityIndicator()
    initialLoad()
    createToolbar()
  }
  
  // MARK: Functions
  
  func initialLoad() {
    // When app starts, we are fetching all the launches but showing the first 20 launches
    // As user scrolls more content will shown
    viewModel.fetchLaunches { (result) in
      switch result {
        case .success(let launches):
          self.allLaunches = launches
          self.copyOfLaunches = launches
          
          self.setPickerViewData(launches)
          self.loadFirstTwentyLaunch()
          
          self.filterBarButton.isEnabled = true
          self.activityIndicator.stopAnimating()
          
          self.tableView.reloadData()
        case .failure(let error):
          print(error, #line, #file)
      }
    }
  }
  
  func setActivityIndicator() {
    activityIndicator.center = view.center
    activityIndicator.hidesWhenStopped = true
    activityIndicator.startAnimating()
    view.addSubview(activityIndicator)
  }
  
  /// Create ToolBar for filter PickerView
  func createToolbar() {
    let toolBar = UIToolbar()
    toolBar.barStyle = .default
    toolBar.sizeToFit()
    
    let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissPicker))
    
    let cancelButton = UIBarButtonItem(title: "Clear Filter", style: .plain, target: self, action: #selector(clearFilter))
    
    let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    let titleButton = UIBarButtonItem(title: "Select Year To Filter", style: .plain, target: self, action: nil)
    // Make button looks like title
    titleButton.isEnabled = false
    
    toolBar.setItems([cancelButton, spaceButton, titleButton, spaceButton, doneButton], animated: true)
    
    toolBar.isUserInteractionEnabled = true
    hiddenTextField.inputAccessoryView = toolBar
  }
  
  @objc func dismissPicker() {
    view.endEditing(true)
  }
  
  @objc func clearFilter() {
    view.endEditing(true)
    launches = []
    numberOfPage = 2
    loadFirstTwentyLaunch()
    isFilterOn = false
    tableView.reloadData()
  }
  
  /// Get all "Year" data from api and append to pickerViewData if does not added before
  func setPickerViewData(_ allLaunches: [Launch]) {
    for launch in allLaunches {
      if !self.pickerViewData.contains(launch.launchYear ?? "Unknown" ) {
        self.pickerViewData.append(launch.launchYear ?? "Unknown" )
      }
    }
  }
  
  func loadFirstTwentyLaunch() {
    var i = 0
    while i < 20 {
      self.launches.append(self.copyOfLaunches[i])
      i += 1
    }
    tableView.reloadData()
  }
  
  // MARK: Actions
  
  @IBAction func filterBarButtonPressed(_ sender: UIBarButtonItem) {
    hiddenTextField.becomeFirstResponder()
  }
  
}

// MARK: - UITableViewDelegate

extension HomeController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    /// Single launch
    let launch = launches[indexPath.row]
    
    guard let vc = storyboard?.instantiateViewController(identifier: Constant.StoryboardId.detail) as? DetailController else { return }
    // Pass data to detail view
    vc.launch = launch
    
    navigationController?.pushViewController(vc, animated: true)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // Calculate the position of one screen length before the bottom of the results
    let scrollViewContentHeight = tableView.contentSize.height
    let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
    
    // When the user has scrolled past the threshold, start loading more
    if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
      // Check page number and isFilterOn and load more
      if numberOfPage == 2 && isFilterOn != true {
        for i in 20...40 {
          launches.append(allLaunches[i])
        }
        numberOfPage = 3
        tableView.reloadData()
      } else if numberOfPage == 3 && isFilterOn != true {
        for i in 41...60 {
          launches.append(allLaunches[i])
        }
        numberOfPage = 4
        tableView.reloadData()
      } else if numberOfPage == 4 && isFilterOn != true {
        for i in 61...80 {
          launches.append(allLaunches[i])
        }
        numberOfPage = 5
        tableView.reloadData()
      } else if numberOfPage == 5  && isFilterOn != true {
        for i in 81..<allLaunches.count {
          launches.append(allLaunches[i])
        }
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
    /// Single launch
    let launch = launches[indexPath.row]
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.UI.homeTableViewCell) as? HomeTableViewCell else { return UITableViewCell() }
    
    // Image
    if let url = URL(string: (launch.links?.missionPatchSmall)!) {
      cell.missionPatchImageView.kf.indicatorType = .activity
      cell.missionPatchImageView.kf.setImage(with: url,  options: [
        .transition(.fade(1)),
        .cacheOriginalImage
      ])
    }
    // Infos
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

// MARK: - UIPickerViewDelegate

extension HomeController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerViewData.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return pickerViewData[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    /// Filtered launches by launch year
    let filteredLaunches = allLaunches.filter { $0.launchYear == pickerViewData[row] }
    launches = filteredLaunches
    
    isFilterOn = true
    tableView.reloadData()
  }
  
}
