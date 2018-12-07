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
      (success: Bool, decodable: Decodable) in
      if success {
        let session = decodable as! Session
        self.presentGenreViewController(session: session)
      } else {
        // Print error message
        // Enable back button
        DispatchQueue.main.async {
          let error = decodable as! Error
          self.messageLabel.text = error.statusMessage
          self.backButton.isEnabled = true
        }
      }
    }
  }
  
  @IBAction func backButtonTapped(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  func presentGenreViewController(session: Session) {
    let storyboard = UIStoryboard.init(name: "tabBar", bundle: nil)
    let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController")
      as! TabBarController
    if let navigationController = tabBarController.viewControllers?.first as? UINavigationController,
      let _ = navigationController.viewControllers.first as? GenreViewController {
      // Dependency injection for session id
      tabBarController.sessionId = session.id
      // Present tabBarController
      self.present(tabBarController, animated: true, completion: nil)
    }
  }
}
