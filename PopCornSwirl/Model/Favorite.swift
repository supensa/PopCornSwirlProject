//
//  Favorite.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 18/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation

/// Represent list of Favorite
class Favorite {
  var list = [Int: Bool]()
  
  func loadList(sessionId: String) {
    FavoriteController().sendRequest(sessionId: sessionId) {
      [weak self] (success, decodable) in

      guard let self = self else { return }

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
  
  /// Swap the status of a movie as favorite or not.
  ///
  /// - Parameters:
  ///   - sessionId: Current session Id
  ///   - movieId: Movie that needs its status to be swapped
  ///   - completion: Closure executed when status swap is completed
  func toggle(sessionId: String, movieId: Int, completion: ((Bool, Decodable) -> ())? = nil) {
    var isFavorite: Bool
    if self.isFavorite(movieId: movieId) {
      isFavorite = false
    } else {
      isFavorite = true
    }
    FavoriteController().set(asFavorite: isFavorite,
                             movieId: movieId,
                             sessionId: sessionId) {
      [weak self] (success, decodable) in

      guard let self = self else { return }

      if success {
        if isFavorite {
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
  
  /// Indicate if the movie belongs to the favorite list
  ///
  /// - Parameter movieId: Id of movie to check
  /// - Returns: true if it is a favorite movie
  func isFavorite(movieId: Int) -> Bool {
    return self.list[movieId] != nil
  }
}
