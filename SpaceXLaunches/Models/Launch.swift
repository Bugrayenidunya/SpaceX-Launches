//
//  Launch.swift
//  SpaceXLaunches
//
//  Created by Bugra's Mac on 21.11.2020.
//

import Foundation

// MARK: - Launch

struct Launch: Codable {
  // Properties
  var flightNumber: Int
  var launchSuccess: Bool
  var missionName: String
  var details: String
  var launchYear, launchDateUTC, launchDateLocal: String
  var links: Links
  var rocket: Rocket
  var launchFailureDetails: LaunchFailureDetails
  
  // CodingKeys
  enum CodingKeys: String, CodingKey {
    case launchYear = "launch_year"
    case missionName = "mission_name"
    case flightNumber = "flight_number"
    case launchSuccess = "launch_success"
    case launchDateUTC = "launch_date_utc"
    case launchDateLocal = "launch_date_local"
    case launchFailureDetails = "launch_failure_details"
    // We don't need raw value for below properties
    case links
    case rocket
    case details
  }
}

// MARK: - Links

struct Links: Codable {
  // Properties
  var missionPatch, missionPatchSmall: String
  var wikipedia, videoLink: String
  
  // CodingKeys
  enum CodingKeys: String, CodingKey {
    case videoLink = "video_link"
    case missionPatch = "mission_patch"
    case missionPatchSmall = "mission_patch_small"
    case wikipedia
  }
}

// MARK: - Rocket

struct Rocket: Codable {
  // Properties
  var rocketID, rocketName, rocketType: String
  
  // CodingKeys
  enum CodingKeys: String, CodingKey {
    case rocketID = "rocket_id"
    case rocketName = "rocket_name"
    case rocketType = "rocket_type"
  }
}

// MARK: - LaunchFailureDetails

struct LaunchFailureDetails: Codable {
  // Properties
  var time: Int
  var reason: String
}
