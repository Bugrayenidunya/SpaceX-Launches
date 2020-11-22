//
//  HomeViewModel.swift
//  SpaceXLaunches
//
//  Created by Bugra's Mac on 21.11.2020.
//

import Foundation

class HomeViewModel {
  
  func fetchLaunches(completion: @escaping(Swift.Result<[Launch], Error>) -> Void) {
    Service.request(endpoint: Endpoint.getLaunches) { (result: Result<[Launch], Error>) in
      switch result {
      case .success(let response):
        completion(Swift.Result.success(response))
      case .failure(let error):
        completion(Swift.Result.failure(error))
      }
    }
  }
  
}
