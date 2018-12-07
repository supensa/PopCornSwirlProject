//
//  Session.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 05/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation
// Properties name needs to be the same as data received in JSON
struct Session: Decodable {
  let id: String
  let success: Bool
  // Change properties name here
  private enum CodingKeys: String, CodingKey {
    case id = "sessionId"
    case success
  }
}
