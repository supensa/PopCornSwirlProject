//
//  GenreListController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 06/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation
import Alamofire


class GenreListController {
  func sendRequest(completion: @escaping (Bool, Decodable) -> Void) {
    let url = API.genreList
    NetworkController.alamofire.request(url, method: .get).responseJSON {
      (response: DataResponse<Any>) in
      NetworkController.process(response: response, type: GenreList.self, completion: completion)
    }
  }
}
