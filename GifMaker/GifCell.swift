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
  private lazy var imageView: UIImageView = {
    let imgView = UIImageView(frame: .zero)
    return imgView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayout()
  }
  
  private func setupLayout() {
    addSubviews([imageView])
    imageView.anchor(top: self.topAnchor,
                     leading: self.leadingAnchor,
                     bottom: self.bottomAnchor,
                     trailing: self.trailingAnchor)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with data: Gif) {
    imageView.image = data.gifImage
  }

}
