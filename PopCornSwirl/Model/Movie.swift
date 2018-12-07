//
//  Movie.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 07/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation

struct Movie: Decodable {
  var posterPath: String?
  var adult: Bool?
  var overview: String?
  var releaseDate: String?
  var genreIds: [Int]?
  var id: Int?
  var originalTitle: String?
  var originalLanguage: String?
  var title: String?
  var backdropPath: String?
  var popularity: Double?
  var voteCount: Int?
  var video: Bool?
  var voteAverage: Double?
}
