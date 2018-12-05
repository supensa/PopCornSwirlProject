//
//  API.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 03/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation

struct API {
  private static let domain = "https://api.themoviedb.org/3/"
  // API.key is in another file not submitted on Github.
  // Please use your own API key
  static let newToken = API.domain + "authentication/token/new?api_key=" + API.key
  static let login = API.domain + "authentication/token/validate_with_login?api_key=" + API.key
  static let newSession = API.domain + "authentication/session/new?api_key=" + API.key
  static let endSession = API.domain + "authentication/session?api_key=" + API.key
}
