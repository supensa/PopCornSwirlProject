//
//  FavoriteController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 15/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation
import Alamofire

/// Class used the "favorite" feature to request list of favorite movies or set a movie as favorite
class FavoriteController {
  func sendRequest(page: Int = 1, sessionId: String, completion: @escaping (Bool, Decodable) -> Void) {
    let url = API.favoritePage
    let parameters: [String: Any] = [
      "api_key": API.key,
      "session_id": "\(sessionId)",
      "sort_by": "created_at.desc",
      "page": page
    ]
    NetworkController.alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
      .responseJSON {
        (response: DataResponse<Any>) in
        NetworkController.process(response: response, type: Page.self, completion: completion)
    }
  }
  
  func set(asFavorite isFavorite: Bool,
                  movieId: Int,
                  sessionId: String,
                  completion: @escaping (Bool, Decodable) -> Void) {
    let url = API.isFavorite + sessionId
    let parameters: [String: Any] = [
      "media_type": "movie",
      "media_id": movieId,
      "favorite": isFavorite
    ]
    NetworkController.alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
      .responseJSON {
        (response: DataResponse<Any>) in
        NetworkController.process(response: response, type: Response.self, completion: completion)
    }
  }
}
