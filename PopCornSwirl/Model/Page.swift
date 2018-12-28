//
//  Page.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 07/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//
import Foundation
// Properties name needs to be the same as data received in JSON
struct Page: Decodable {
  var number: Int
  var totalResults: Int
  var total: Int
  var results: [Movie]
  // Change properties name here if needed
  private enum CodingKeys: String, CodingKey {
    case number = "page"
    case total = "totalPages"
    case totalResults, results
  }
}
