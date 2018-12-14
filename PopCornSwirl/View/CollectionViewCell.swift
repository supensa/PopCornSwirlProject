//
//  CollectionViewCell.swift
//  PopCornSwirl
//
//  Created by Spencer Forrest on 08/12/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
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
