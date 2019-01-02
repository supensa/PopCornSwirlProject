//
//  MovieController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 15/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation
import Alamofire
class MovieController {
  func sendRequest(movieId: Int, completion: @escaping (Bool, Decodable) -> Void) {
    let url = API.movie + "\(movieId)"
    let parameters: [String: Any] = [
      "api_key": API.key
    ]
    NetworkController.alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
      .responseJSON {
        (response: DataResponse<Any>) in
        NetworkController.process(response: response, type: Movie.self, completion: completion)
    }
  }
}
