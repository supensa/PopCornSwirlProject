//
//  NoteViewController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 03/01/2019.
//  Copyright © 2019 Spencer Forrest. All rights reserved.
//

import UIKit
import GoogleMobileAds
import CoreData

class NoteViewController: UIViewController {
  
  @IBOutlet weak var poster: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var saveButton: UIButton!
  @IBOutlet weak var bannerView: GADBannerView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
  
  private var accessoryView: UIView!
  
  var movie: Movie!
  var image: UIImage?
  var dataController: NoteDataController!
  var username: String {
    guard let tabBarController = navigationController?.tabBarController as? TabBarController
      else { fatalError() }
    return tabBarController.username!
  }
  
  private let defaultColor = UIColor(red: 101/255, green: 214/255, blue: 118/255, alpha: 1)
  private let defaultText = "Write a note here."
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupViews()
    self.setupGoogleBannerView()
    self.setupDataController()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.setDataInViews()
    self.registerNotifications()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.unregisterNotifications()
  }
  
  func setupViews() {
    self.saveButton.layer.cornerRadius = 5
    self.saveButton.clipsToBounds = true
  }
  
  func setupGoogleBannerView() {
    // Sample Ad unit ID for banner: ca-app-pub-3940256099942544/2934735716
    bannerView.adUnitID = API.adUnitID
    bannerView.rootViewController = self
    let request = GADRequest()
    request.tag(forChildDirectedTreatment: true)
    request.contentURL = "https://www.themoviedb.org/movie/\(self.movie.id)"
    request.testDevices = [kGADSimulatorID]
    bannerView.load(request)
  }
  
  func setupDataController() {
    let context = self.getManagedObjectContext()
    self.dataController = NoteDataController(context)
  }
  
  func setDataInViews() {
    self.poster.image = self.image
    self.titleLabel.text = self.movie.title
    let note = dataController.fetchNote(movieId: self.movie.id, username: self.username)
    self.textView.text = note?.comment ?? self.defaultText
  }
  
  @IBAction func saveButtonTapped(_ sender: Any) {
    guard let tabBarController = self.navigationController?.tabBarController as? TabBarController
      else { fatalError() }

    self.textView.resignFirstResponder()
    
    if self.textView.text == self.defaultText ||
      self.textView.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
      self.dataController.removeNote()
      self.textView.text = self.defaultText
    } else {
      // Add note to Persitent Store
      let username = tabBarController.username!
      self.dataController.addNote(movieId: self.movie.id, username: username, comment: self.textView.text)
    }
  }
  
  func getManagedObjectContext() -> NSManagedObjectContext {
    guard let navigationController = navigationController,
      let tabBarController = navigationController.tabBarController as? TabBarController,
      let persistentStore = tabBarController.persistentContainer
      else {
        fatalError("NSPersistentContainer not found")
    }
    return persistentStore.viewContext
  }
  
  func changeBackGroundColor(_ button: UIButton, color: UIColor, duration: TimeInterval = 0.5) {
    UIView.animate(withDuration: duration, animations: {
      button.backgroundColor = color
    })
  }
}

// MARK: Keyboard appearance interaction
extension NoteViewController {
  func registerNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  func unregisterNotifications() {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  @objc func keyboardWillShow(notification: NSNotification){
    guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    let height = keyboardFrame.cgRectValue.size.height
    scrollView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
      - bannerView.frame.height
      - tabBarController!.tabBar.frame.size.height
    
    let y = scrollView.contentOffset.y
    let x = scrollView.contentOffset.x
    scrollView.contentOffset = CGPoint(x: x, y: y + height / 2)
  }
  
  @objc func keyboardWillHide(notification: NSNotification){
    scrollView.contentInset.bottom = 0
  }
}

// MARK: UITextViewDelegate
extension NoteViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == self.defaultText {
      textView.text = ""
    }
  }
}
