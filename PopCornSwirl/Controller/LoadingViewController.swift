//
//  LoadingViewController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 03/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
  
  var username: String!
  var password: String!
  
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var backButton: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.backButton.isEnabled = false
    self.messageLabel.adjustsFontSizeToFitWidth = true
    
    AuthenticationController().requestNewToken(username: username!, password: password!) {
      (success, result) in
      if success {
        let sessionId = result
        self.presentWelcomViewController(sessionId: sessionId)
      } else {
        // Print error message
        // Enable back button
        DispatchQueue.main.async {
          self.messageLabel.text = result
          self.backButton.isEnabled = true
        }
      }
    }
  }
  
  @IBAction func backButtonTapped(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  func presentWelcomViewController(sessionId: String) {
    let storyboard = UIStoryboard.init(name: "main", bundle: nil)
    let welcomeViewController = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController")
      as! WelcomeViewController
    welcomeViewController.sessionId = sessionId
    self.present(welcomeViewController, animated: true, completion: nil)
  }
}
