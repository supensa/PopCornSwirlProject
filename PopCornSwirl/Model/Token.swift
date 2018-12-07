//
//  Token.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 07/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation

struct Token: Decodable {
  let success: Bool
  let expiresAt: String
  let requestToken: String
}
