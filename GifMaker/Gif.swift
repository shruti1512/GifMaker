//
//  Gif.swift
//  GifMaker_Swift_Template
//
//  Created by Shruti Sharma on 2/8/21.
//  Copyright © 2021 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

struct Gif: Hashable {
  let url: URL?
  let videoURL: URL?
  var caption: String?
  var gifImage: UIImage? {
    guard let url = url else { return nil }
    return UIImage.gif(url: url.absoluteString)
  }
  var gifData: Data?
  let identifier = UUID().uuidString

  func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }
  
  static func ==(lhs: Gif, rhs: Gif) -> Bool {
    return lhs.identifier == rhs.identifier
  }
}
