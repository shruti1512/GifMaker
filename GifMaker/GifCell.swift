//
//  SavedGifCollectionViewCell.swift
//  GifMaker
//
//  Created by Shruti Sharma on 2/18/21.
//  Copyright © 2021 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class GifCell: UICollectionViewCell, SelfConfigurable {
  static var reuseIdentifier = String(describing: GifCell.self)
  
  typealias T = Gif
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with data: T) {
    
  }

}
