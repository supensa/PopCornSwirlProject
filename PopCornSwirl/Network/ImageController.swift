//
//  ImageController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 08/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation
import UIKit

/// Class downloading an image from a distant server
class ImageController {
  func downloadFrom(relativePath: String, completion: @escaping (UIImage)->()) {
    let url = "https://image.tmdb.org/t/p/w185" + relativePath
    NetworkController.getRequest(url: url) {
      (data, respense, error) in
      if let data = data, let image = UIImage.init(data: data) {
        completion(image)
      }
    }
  }
}
