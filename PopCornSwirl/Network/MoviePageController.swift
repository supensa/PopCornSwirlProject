//
//  MoviePageController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 07/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation
import Alamofire

/// Class used to request a list of movies for a specific Genre from web service
class MoviePageController {
  func sendRequest(page:Int = 1, genreId: Int, completion: @escaping (Bool, Decodable) -> Void) {
    let url = API.moviePage
    let parameters: [String: Any] = [
      "api_key": API.key,
      "with_genres": genreId,
      "page": page,
      "sort_by": "popularity.desc",
      "include_adult": "false",
      "language": "EN-US"
    ]
    NetworkController.alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
      .responseJSON {
        (response: DataResponse<Any>) in
        NetworkController.process(response: response, type: Page.self, completion: completion)
    }
  }
}
