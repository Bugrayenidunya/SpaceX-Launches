//
//  Service.swift
//  SpaceXLaunches
//
//  Created by Bugra's Mac on 21.11.2020.
//

import Foundation

class Service {
  
  // MARK: - Generic Request Function
  
  class func request<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<[T], Error>) -> ()) {
    // Setting up components from Endpoint class
    var components = URLComponents()
    components.scheme = endpoint.scheme
    components.host = endpoint.host
    components.path = endpoint.path
    
    // Check if url is valid and create url request
    guard let url = components.url else { return }
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = endpoint.method
    
    // Create session and dataTask and start request
    let session = URLSession(configuration: .default)
    let dataTask = session.dataTask(with: urlRequest) { data, response, error in
      // Check error
      if error != nil {
        completion(.failure(error!))
        print(error!.localizedDescription)
        
        return
      }
      guard response != nil, let data = data else { return }
      
      // No error, decode response
      let responseObject = try! JSONDecoder().decode([T].self, from: data)
      
      // While networking happens in background call completion block on main thread when success
      DispatchQueue.main.async {
        completion(.success(responseObject))
      }
    }
    dataTask.resume()
  }
  
}
