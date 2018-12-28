//
//  ImageController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 08/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class ImageController {  
  func downloadFrom(relativePath: String, completion: @escaping (UIImage)->()) {
    let url = "https://image.tmdb.org/t/p/w185" + relativePath
    Alamofire.request(url).responseImage {
      (response: DataResponse<Image>) in
      if let image = response.result.value {
        completion(image)
      }
    }
  }
}
