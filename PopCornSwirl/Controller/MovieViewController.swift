//
//  MovieViewController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 07/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {
  
  var currentGenreIndex: Int!
  var genreList: GenreList!
  var currentGenre: Genre {
    return genreList.genres[currentGenreIndex]
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
