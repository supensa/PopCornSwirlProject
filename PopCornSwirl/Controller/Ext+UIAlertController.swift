//
//  Ext+UIAlertController.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 02/01/2019.
//  Copyright © 2019 Spencer Forrest. All rights reserved.
//

import UIKit

extension UIAlertController {
  static func serverAlert() -> UIAlertController {
    let title = "Server not available"
    let message = "Please try later."
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alert.addAction(action)
    return alert
  }
}
