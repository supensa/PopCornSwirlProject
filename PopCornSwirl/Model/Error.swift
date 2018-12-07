//
//  Error.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 05/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation
// Properties name needs to be the same as data received in JSON
struct Error: Decodable {
  let id: Int?
  let statusMessage: String
  // Change properties name here if needed
  private enum CodingKeys: String, CodingKey {
    case id = "statusCode"
    case statusMessage
  }
}
