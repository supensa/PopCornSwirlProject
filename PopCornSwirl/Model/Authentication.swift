//
//  Authentication.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 11/04/2021.
//  Copyright © 2021 Spencer Forrest. All rights reserved.
//

import Foundation

struct Authentication: Encodable {
  let username: String?
  let password: String?
  let requestToken: String
}
