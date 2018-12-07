//
//  MoviePage.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 07/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation

struct MoviePage: Decodable {
  var page: Int?
  var totalResults: Int?
  var totalPages: Int?
  var results: [Movie]?
}
