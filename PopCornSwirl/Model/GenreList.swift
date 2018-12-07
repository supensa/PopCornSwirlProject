//
//  MovieList.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 05/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation
// Properties name needs to be the same as data received in JSON
struct GenreList: Decodable {
  let genres: [Genre]
}
