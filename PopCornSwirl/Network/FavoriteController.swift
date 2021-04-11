//
//  FavoriteController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 15/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation

struct FavoriteRequest: Encodable {
  let mediaType: String
  let mediaId: Int
  let favorite: Bool
}

/// Class used the "favorite" feature to request list of favorite movies or set a movie as favorite
class FavoriteController {
  func sendRequest(page: Int = 1, sessionId: String, completion: @escaping (Bool, Decodable) -> Void) {
    
    let queryItems: [URLQueryItem] = [
      URLQueryItem.init(name: "api_key", value: API.key),
      URLQueryItem.init(name: "session_id", value: "\(sessionId)"),
      URLQueryItem.init(name: "sort_by", value: "created_at.desc"),
      URLQueryItem.init(name: "page", value: "\(page)")
    ]
    
    var urlComponents = URLComponents(string: API.favoritePage)!
    urlComponents.queryItems = queryItems
    
    let url: String = urlComponents.string!
    
    NetworkController.getRequest(url: url, errorHandler: completion) {
      (data, response, error) in
      if let data = data {
        NetworkController.process(data: data, type: Page.self, completion: completion)
      } else {
        completion(false, Response.init(id: nil, statusMessage: "Server failed to get the favorite movie list"))
      }
    }
  }
  
  func set(asFavorite isFavorite: Bool,
           movieId: Int,
           sessionId: String,
           completion: @escaping (Bool, Decodable) -> Void) {
    
    let url: String = API.isFavorite + sessionId
    let favoriteRequest = FavoriteRequest.init(mediaType: "movie", mediaId: movieId, favorite: isFavorite)
    
    NetworkController.postRequest(url: url, encodable: favoriteRequest, errorHandler: completion) {
      (data, response, error) in
      if let data = data {
        NetworkController.process(data: data, type: Response.self, completion: completion)
      } else {
        completion(false, Response.init(id: nil, statusMessage: "Server failed to set the movie as favorite"))
      }
    }
  }
}
