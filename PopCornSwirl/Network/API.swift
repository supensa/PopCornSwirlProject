//
//  API.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 03/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation

struct API {
  // API.key is in another file not submitted on Github.
  // Please use your own API key
//  private static let key = "Enter your API Key here"
  private static let domain = "https://api.themoviedb.org/3/"
  
  static let newToken = API.domain + "authentication/token/new?api_key=" + API.key
  static let login = API.domain + "authentication/token/validate_with_login?api_key=" + API.key
  static let newSession = API.domain + "authentication/session/new?api_key=" + API.key
  static let endSession = API.domain + "authentication/session?api_key=" + API.key
  static let genreList = API.domain + "genre/movie/list?language=en-US&api_key=" + API.key
  static let moviePage = API.domain + "discover/movie"
}
