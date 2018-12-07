//
//  MoviePageController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 07/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation
import Alamofire

class MoviePageController {
  func requestMovie(page:Int = 1, genreIndex: Int, completion: @escaping (Bool, Decodable) -> Void) {
    let url = API.moviePage
    let parameters: [String: Any] = [
      "api_key": API.key,
      "with_genres": genreIndex,
      "page": page,
      "include_adult": false,
      "language": "US-EN"
    ]
    Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
      .responseJSON {
        (response) in
        NetworkController.process(response: response, type: MoviePage.self, completion: completion)
    }
  }
}
