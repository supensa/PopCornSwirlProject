//
//  MovieImage.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 08/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

class MovieImage {
  private init() {}
  // Use Movie id as key to get image (poster or backDrop) in memory
  static var poster = [Int: UIImage]()
  static var backDrop = [Int: UIImage]()
}
