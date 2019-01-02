//
//  MovieDetailViewController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 12/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit
import GoogleMobileAds

class MovieDetailViewController: UIViewController {
  @IBOutlet weak var poster: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var overviewTextView: UITextView!
  @IBOutlet weak var watchedListButton: UIButton!
  @IBOutlet weak var favoriteButton: UIButton!
  
  @IBOutlet weak var bannerView: GADBannerView!
  
  var movie: Movie!
  
  private let defaultColor = UIColor(red: 101/255, green: 214/255, blue: 118/255, alpha: 1)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let id = movie.id
    self.poster.image = MovieImage.poster[id]
    self.titleLabel.text = self.movie.title
    self.overviewTextView.isScrollEnabled = false
    self.overviewTextView.text = self.movie.overview
    self.setupButtons()
    self.updateButtons()
    self.setupGoogleBannerView()
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(updateFavoriteButton),
                                           name: Notification.Name("favoriteStatusChangeNotification"),
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(updateWatchedListButton),
                                           name: Notification.Name("watchedListStatusChangeNotification"),
                                           object: nil)
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
    
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.overviewTextView.isScrollEnabled = true
  }
  
  func setupButtons() {
    self.favoriteButton.layer.cornerRadius = 5
    self.favoriteButton.clipsToBounds = true
    self.watchedListButton.layer.cornerRadius = 5
    self.watchedListButton.clipsToBounds = true
  }
  
  func updateButtons() {
    self.updateFavoriteButton()
    self.updateWatchedListButton()
  }
  
  @objc func updateFavoriteButton() {
    self.favoriteButton.isUserInteractionEnabled = true
    let tabBar = self.navigationController?.tabBarController as! TabBarController
    if tabBar.favorite.isFavorite(movieId: self.movie.id) {
      self.favoriteButton.setTitle("Remove Favorite", for: .normal)
      self.changeBackGroundColor(self.favoriteButton, color: .red)
      } else {
      self.favoriteButton.setTitle("Add Favorite", for: .normal)
      self.changeBackGroundColor(self.favoriteButton, color: self.defaultColor)
    }
    self.favoriteButton.layoutIfNeeded()
  }
  
  @objc func updateWatchedListButton() {
    self.watchedListButton.isUserInteractionEnabled = true
    let tabBar = self.navigationController?.tabBarController as! TabBarController
    if tabBar.watchedList.isInWatchedList(movieId: self.movie.id) {
      self.watchedListButton.setTitle("Remove Watched", for: .normal)
      self.changeBackGroundColor(self.watchedListButton, color: .red)
    } else {
      self.watchedListButton.setTitle("Add Watched", for: .normal)
      self.changeBackGroundColor(self.watchedListButton, color: self.defaultColor)
    }
    self.watchedListButton.layoutIfNeeded()
  }
  
  @IBAction func favoriteBtnTapped(_ sender: Any) {
    let tabBar = self.navigationController?.tabBarController as! TabBarController
    let sessionId = tabBar.sessionId!
    self.favoriteButton.setTitle("WAITING...", for: .normal)
    self.changeBackGroundColor(self.favoriteButton, color: .lightGray, duration: 0.2)
    self.favoriteButton.isUserInteractionEnabled = false
    tabBar.favorite.toggle(sessionId: sessionId, movieId: self.movie.id) {
      (success, decodable) in
      if success {
        NotificationCenter.default.post(name: Notification.Name("favoriteStatusChangeNotification"),
                                        object: nil)
      } else {
         // Handle Network Error
        let error = decodable as! Response
        print(error.statusMessage)
        DispatchQueue.main.async {
          let alert = UIAlertController.serverAlert()
          self.present(alert, animated: true, completion: nil)
          self.updateFavoriteButton()
        }
      }
    }
  }
  
  @IBAction func watchedListBtnTapped(_ sender: Any) {
    let tabBar = self.navigationController?.tabBarController as! TabBarController
    let sessionId = tabBar.sessionId!
    self.watchedListButton.setTitle("WAITING...", for: .normal)
    self.changeBackGroundColor(self.watchedListButton, color: .lightGray, duration: 0.2)
    self.watchedListButton.isUserInteractionEnabled = false
    tabBar.watchedList.toggle(sessionId: sessionId, movieId: self.movie.id){
      (success, decodable) in
      if success {
        NotificationCenter.default.post(name: Notification.Name("watchedListStatusChangeNotification"),
                                        object: nil)
      } else {
        // Handle Network Error
        let error = decodable as! Response
        print(error.statusMessage)
        DispatchQueue.main.async {
          let alert = UIAlertController.serverAlert()
          self.present(alert, animated: true, completion: nil)
          self.updateWatchedListButton()
        }
      }
    }
  }
  
  func changeBackGroundColor(_ button: UIButton, color: UIColor, duration: TimeInterval = 0.5) {
    UIView.animate(withDuration: duration, animations: {
      button.backgroundColor = color
    })
  }
}
