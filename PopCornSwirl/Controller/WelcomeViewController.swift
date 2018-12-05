//
//  WelcomeViewController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 05/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
  
  var sessionId: String!
  
  @IBOutlet weak var welcomeLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.welcomeLabel.adjustsFontSizeToFitWidth = true
    self.welcomeLabel.text = sessionId
  }
}
