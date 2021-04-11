//
//  MovieController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 15/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation

/// Class requesting the details of a sepcific movie from web service
class MovieController {
  func sendRequest(movieId: Int, completion: @escaping (Bool, Decodable) -> Void) {
    let url = API.movie + "\(movieId)?api_key=\(API.key)"
    
    NetworkController.getRequest(url: url, errorHandler: completion) {
      (data, response, error) in
      if let data = data {
        NetworkController.process(data: data, type: Movie.self, completion: completion)
      } else {
        completion(false, Response.init(id: nil, statusMessage: "Server failed to return the movie"))
      }
    }
  }
}
