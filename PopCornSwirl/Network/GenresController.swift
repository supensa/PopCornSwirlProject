//
//  GenresController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 06/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation
import Alamofire


class GenresController {
  func requestGenreList(completion: @escaping (Bool, Decodable) -> Void) {
    let url = API.genreList
    Alamofire.request(url, method: .get).responseJSON {
      (response: DataResponse<Any>) in
      NetworkController.process(response: response, type: GenreList.self, completion: completion)
    }
  }
}
