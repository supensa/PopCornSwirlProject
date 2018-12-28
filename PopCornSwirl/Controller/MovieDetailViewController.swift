//
//  MovieDetailViewController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 12/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
  
  // TODO: Query API in case another tab updates Watched or Favorite list
  
  @IBOutlet weak var poster: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var overviewTextView: UITextView!
  @IBOutlet weak var watchedListButton: UIButton!
  @IBOutlet weak var favoriteButton: UIButton!
  
  var movie: Movie!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let id = movie.id
    self.poster.image = MovieImage.poster[id]
    self.titleLabel.text = self.movie.title
    self.overviewTextView.isScrollEnabled = false
    self.overviewTextView.text = self.movie.overview
    self.setupButtons()
    self.updateButtons()
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(updateFavoriteButtons),
                                           name: Notification.Name("favoriteStatusChangeNotification"),
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(updateWatchedListButtons),
                                           name: Notification.Name("watchedListStatusChangeNotification"),
                                           object: nil)
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
    self.updateFavoriteButtons()
    self.updateWatchedListButtons()
  }
  
  @objc func updateFavoriteButtons() {
    self.favoriteButton.isUserInteractionEnabled = true
    let tabBar = self.navigationController?.tabBarController as! TabBarController
    if tabBar.favorite.isFavorite(movieId: self.movie.id) {
      self.favoriteButton.setTitle("Remove Favorite", for: .normal)
      UIView.animate(withDuration: 0.5, animations: {
        self.favoriteButton.backgroundColor = UIColor.red
      })
      } else {
      self.favoriteButton.setTitle("Add Favorite", for: .normal)
      UIView.animate(withDuration: 0.5, animations: {
        self.favoriteButton.backgroundColor = UIColor.green
      })
    }
    self.favoriteButton.layoutIfNeeded()
  }
  
  @objc func updateWatchedListButtons() {
    self.watchedListButton.isUserInteractionEnabled = true
    let tabBar = self.navigationController?.tabBarController as! TabBarController
    if tabBar.watchedList.isInWatchedList(movieId: self.movie.id) {
      self.watchedListButton.setTitle("Remove Watched", for: .normal)
      UIView.animate(withDuration: 0.5, animations: {
        self.watchedListButton.backgroundColor = UIColor.red
      })
    } else {
      self.watchedListButton.setTitle("Add Watched", for: .normal)
      UIView.animate(withDuration: 0.5, animations: {
        self.watchedListButton.backgroundColor = UIColor.green
      })
    }
    self.watchedListButton.layoutIfNeeded()
  }
  
  @IBAction func favoriteBtnTapped(_ sender: Any) {
    let tabBar = self.navigationController?.tabBarController as! TabBarController
    let sessionId = tabBar.sessionId!
    self.favoriteButton.setTitle("WAITING...", for: .normal)
    UIView.animate(withDuration: 0.2, animations: {
      self.favoriteButton.backgroundColor = UIColor.lightGray
    })
    self.favoriteButton.isUserInteractionEnabled = false
    tabBar.favorite.toggle(sessionId: sessionId, movieId: self.movie.id) {
      (success, decodable) in
      if success {
        NotificationCenter.default.post(name: Notification.Name("favoriteStatusChangeNotification"),
                                        object: nil)
      } else {
         // Handle NetWork Error
      }
    }
  }
  
  @IBAction func watchedListBtnTapped(_ sender: Any) {
    let tabBar = self.navigationController?.tabBarController as! TabBarController
    let sessionId = tabBar.sessionId!
    self.watchedListButton.setTitle("WAITING...", for: .normal)
    UIView.animate(withDuration: 0.2, animations: {
      self.watchedListButton.backgroundColor = UIColor.lightGray
    })
    self.watchedListButton.isUserInteractionEnabled = false
    tabBar.watchedList.toggle(sessionId: sessionId, movieId: self.movie.id){
      (success, decodable) in
      if success {
        NotificationCenter.default.post(name: Notification.Name("watchedListStatusChangeNotification"),
                                        object: nil)
      } else {
        // Handle NetWork Error
      }
    }
  }
}
