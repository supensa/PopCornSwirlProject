//
//  Watched.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 18/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation

class Watched {
  var list = [Int: Bool]()
  
  func loadList(sessionId: String) {
    WatchedListController().sendRequest(sessionId: sessionId) { (success, decodable) in
      if success {
        let favoritePage = decodable as! Page
        let movies = favoritePage.results
        for movie in movies {
          self.list[movie.id] = true
        }
        let page = favoritePage.number
        let totalPages = favoritePage.total
        // Request the next page until we have all the favorties Movie
        if page < totalPages {
          self.loadList(sessionId: sessionId)
        }
      }
    }
  }
  
  func toggle(sessionId: String, movieId: Int, completion: ((Bool, Decodable) -> ())? = nil) {
    var inWatchedList: Bool
    if self.isInWatchedList(movieId: movieId) {
      inWatchedList = false
    } else {
      inWatchedList = true
    }
    WatchedListController().set(inWatchedList: inWatchedList,
                             movieId: movieId,
                             sessionId: sessionId) {
      (success, decodable) in
      if success {
        if inWatchedList {
          self.list[movieId] = true
        } else {
          self.list[movieId] = nil
        }
      }
      if let completion = completion {
        completion(success, decodable)
      }
    }
  }
  
  func isInWatchedList(movieId: Int) -> Bool {
    return self.list[movieId] != nil
  }
}