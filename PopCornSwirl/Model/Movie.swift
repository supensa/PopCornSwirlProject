//
//  Movie.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 07/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation
// Properties name needs to be the same as data received in JSON
struct Movie: Decodable {
  var id: Int
  var title: String
  var overview: String
  var genreIds: [Int]
  var posterPath: String?
}
