//
//  MoviePageController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 07/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation

/// Class used to request a list of movies for a specific Genre from web service
class MoviePageController {
  func sendRequest(page:Int = 1, genreId: Int, completion: @escaping (Bool, Decodable) -> Void) {
    
    let queryItems: [URLQueryItem] = [
      URLQueryItem.init(name: "api_key", value: API.key),
      URLQueryItem.init(name: "with_genres", value: "\(genreId)"),
      URLQueryItem.init(name: "page", value: "\(page)"),
      URLQueryItem.init(name: "sort_by", value: "popularity.desc"),
      URLQueryItem.init(name: "include_adult", value: "false"),
      URLQueryItem.init(name: "language", value: "EN-US")
    ]
    
    var urlComponents = URLComponents(string: API.moviePage)!
    urlComponents.queryItems = queryItems
    
    let url: String = urlComponents.string!
    
    NetworkController.getRequest(url: url, errorHandler: completion) {
      (data, response, error) in
      if let data = data {
        NetworkController.process(data: data, type: Page.self, completion: completion)
      } else {
        completion(false, Response(id: nil, statusMessage: "Server failed to return the list of movies"))
      }
    }
  }
}
