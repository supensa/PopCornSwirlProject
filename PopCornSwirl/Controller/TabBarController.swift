//
//  TabBarController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 06/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
  var sessionId: String!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.selectedIndex = 0
  }
}
