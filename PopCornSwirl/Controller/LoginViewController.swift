//
//  LoginViewController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 29/11/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
  
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var createAccountButton: UIButton!
  
  var persistentContainer: NSPersistentContainer!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupLoginButton()
    self.setupCreateAccountButton()
    self.setupTextFields()
    // Looks for single or multiple taps.
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    view.addGestureRecognizer(tap)
    self.passwordTextField.inputAssistantItem.leadingBarButtonGroups = []
    self.passwordTextField.inputAssistantItem.trailingBarButtonGroups = []
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.usernameTextField.text = ""
    self.passwordTextField.text = ""
  }
  
  func setupLoginButton() {
    self.loginButton.layer.cornerRadius = 5
    self.loginButton.clipsToBounds = true
  }
  
  func setupCreateAccountButton() {
    self.createAccountButton.layer.cornerRadius = 5
    self.createAccountButton.clipsToBounds = true
  }
  
  func setupTextFields() {
    self.passwordTextField.isSecureTextEntry = true
    self.passwordTextField.inputAssistantItem.leadingBarButtonGroups = []
    self.passwordTextField.inputAssistantItem.trailingBarButtonGroups = []
    self.usernameTextField.inputAssistantItem.leadingBarButtonGroups = []
    self.usernameTextField.inputAssistantItem.trailingBarButtonGroups = []
  }
  
  // Calls this function when the tap is recognized.
  @objc func dismissKeyboard() {
    // Causes the view (or one of its embedded text fields) to resign the first responder status.
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
    loadingViewController.persistentContainer = self.persistentContainer
    loadingViewController.modalPresentationStyle = .fullScreen
    self.present(loadingViewController, animated: true, completion: nil)
  }
  
  /// Create an account on the website
  ///
  /// - Parameter sender: Button being tapped
  @IBAction func createAccountButtonTapped(_ sender: Any) {
    let url = URL(string: "https://www.themoviedb.org/account/signup")
    if let url = url {
      UIApplication.shared.open(url,
                                options: [:],
                                completionHandler: nil)
    }
  }
}

