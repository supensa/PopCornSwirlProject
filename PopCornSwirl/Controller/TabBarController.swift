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
  var watchedList = Watched()
  var favorite = Favorite()
  private var watchedListDelegation: WatchedListDelegation?
  private var favoriteDelegation: FavoriteDelegation?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.selectedIndex = 0
    self.delegate = self
    favorite.loadList(sessionId: self.sessionId)
    watchedList.loadList(sessionId: self.sessionId)
  }
  
  private class FavoriteDelegation: MovieDelegate {
    private var sessionId: String
    
    init(sessionId: String) {
      self.sessionId = sessionId
    }
    
    func requestDataFromNetwork(page: Int,
                                completion: @escaping (Bool, Decodable) -> ()) {
      FavoriteController().sendRequest(page:page, sessionId: sessionId) {
        (success, decodable) in
        completion(success, decodable)
      }
    }
  }
  
  private class WatchedListDelegation: MovieDelegate {
    private var sessionId: String
    
    init(sessionId: String) {
      self.sessionId = sessionId
    }
    
    func requestDataFromNetwork(page: Int,
                                completion: @escaping (Bool, Decodable) -> ()) {
      WatchedListController().sendRequest(page:page, sessionId: sessionId) {
        (success, decodable) in
        completion(success, decodable)
      }
    }
  }
}

// MARK: --> UITabBarControllerDelegate
extension TabBarController: UITabBarControllerDelegate {
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    let selectedIndex = tabBarController.selectedIndex
    if selectedIndex == 1,
      let navigationController = viewController as? UINavigationController,
      let viewController = navigationController.viewControllers.first as? MovieViewController {
      if self.favoriteDelegation == nil {
        self.favoriteDelegation = FavoriteDelegation.init(sessionId: self.sessionId)
        viewController.delegate = self.favoriteDelegation
      }
    }
    if selectedIndex == 2,
      let navigationController = viewController as? UINavigationController,
      let viewController = navigationController.viewControllers.first as? MovieViewController {
      if self.watchedListDelegation == nil {
        self.watchedListDelegation = WatchedListDelegation.init(sessionId: self.sessionId)
        viewController.delegate = watchedListDelegation
      }
    }
  }
}
