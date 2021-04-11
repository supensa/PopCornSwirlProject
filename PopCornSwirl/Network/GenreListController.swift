//
//  GenreListController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 06/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation


/// Class used to get the list of the different Genres from web service
class GenreListController {
  func sendRequest(completion: @escaping (Bool, Decodable) -> Void) {
    let url = API.genreList
    NetworkController.getRequest(url: url, errorHandler: completion) {
      (data, response, error) in
      if let data = data {
        NetworkController.process(data: data, type: GenreList.self, completion: completion)
      } else {
        completion(false, Response.init(id: nil, statusMessage: "Could not receive movie genre list"))
      }
    }
  }
}
