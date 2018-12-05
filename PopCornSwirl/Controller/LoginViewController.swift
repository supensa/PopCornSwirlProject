//
//  LoginViewController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 29/11/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.passwordTextField.isSecureTextEntry = true
    //Looks for single or multiple taps.
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    view.addGestureRecognizer(tap)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.usernameTextField.text = ""
    self.passwordTextField.text = ""
  }
  
  //Calls this function when the tap is recognized.
  @objc func dismissKeyboard() {
    //Causes the view (or one of its embedded text fields) to resign the first responder status.
    view.endEditing(true)
  }
  
  /// Present Loading View Controller
  ///
  /// - Parameter sender: Button being tapped
  @IBAction func loginButtonTapped(_ sender: UIButton) {
    let storyboard = UIStoryboard.init(name: "login", bundle: nil)
    let loadingViewController =
      storyboard.instantiateViewController(withIdentifier: "LoadingViewController") as! LoadingViewController
    loadingViewController.username =  self.usernameTextField.text
    loadingViewController.password =  self.passwordTextField.text
    self.present(loadingViewController, animated: true, completion: nil)
  }
}

