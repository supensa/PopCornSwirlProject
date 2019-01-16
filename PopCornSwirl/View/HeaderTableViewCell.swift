//
//  HeaderTableViewCell.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 16/01/2019.
//  Copyright © 2019 Spencer Forrest. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

  @IBOutlet weak var poster: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
  func populate(title: String?) {
    self.titleLabel.adjustsFontSizeToFitWidth = true
    self.titleLabel.text = title
  }
  
  func setImage(image: UIImage?) {
    self.poster.image = image
    self.poster.backgroundColor = UIColor.clear
  }
}
