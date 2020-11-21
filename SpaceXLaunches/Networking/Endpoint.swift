//
//  Endpoint.swift
//  SpaceXLaunches
//
//  Created by Bugra's Mac on 21.11.2020.
//

import Foundation

// MARK: - Endpoints for Service

enum Endpoint {
  /// Endpoint for getting all launches
  case getLaunches
  
  /// Schemes for each endpoint
  var scheme: String {
    switch self {
      case .getLaunches:
        return "https"
    }
  }
  
  /// Hosts for each endpoint
  var host: String {
    switch self {
      case .getLaunches:
        return "api.spacexdata.com"
    }
  }
  
  /// Paths for each endpoint
  var path: String {
    switch self {
      case .getLaunches:
        return "/v2/launches"
    }
  }
  
  /// Methods for each endpoint
  var method: String {
    switch self {
      case .getLaunches:
        return "GET"
    }
  }
}
