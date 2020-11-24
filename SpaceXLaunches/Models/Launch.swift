//
//  Launch.swift
//  SpaceXLaunches
//
//  Created by Bugra's Mac on 21.11.2020.
//

import Foundation

// MARK: - Launch Model

struct Launch: Codable {
  // MARK: Properties
  let flightNumber: Int?
  let launchSuccess: Bool?
  let missionName: String?
  let details: String?
  let launchYear, launchDateUTC, launchDateLocal: String?
  let links: Links?
  let rocket: Rocket?
  let launchFailureDetails: LaunchFailureDetails?
  
  // MARK: Codingkeys
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

// MARK: - Links Model

struct Links: Codable {
  // MARK: Properties
  let missionPatch, missionPatchSmall: String?
  let wikipedia, videoLink, articleLink: String?
  
  // MARK: Codingkeys
  enum CodingKeys: String, CodingKey {
    case videoLink = "video_link"
    case articleLink = "article_link"
    case missionPatch = "mission_patch"
    case missionPatchSmall = "mission_patch_small"
    case wikipedia
  }
}

// MARK: - Rocket Model

struct Rocket: Codable {
  // MARK: Properties
  let rocketID, rocketName, rocketType: String?
  
  // MARK: Codingkeys
  enum CodingKeys: String, CodingKey {
    case rocketID = "rocket_id"
    case rocketName = "rocket_name"
    case rocketType = "rocket_type"
  }
}

// MARK: - LaunchFailureDetails Model

struct LaunchFailureDetails: Codable {
  // MARK: Properties
  let time: Int?
  let reason: String?
  
  // MARK: Codingkeys
  enum CodingKeys: String, CodingKey {
    case time
    case reason
  }
}
