//
//  Gif.swift
//  GifMaker_Swift_Template
//
//  Created by Shruti Sharma on 2/8/21.
//  Copyright © 2021 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class Gif {
  let url: URL?
  let videoURL: URL?
  let caption: String?
  let gifImage: UIImage?
  var gifData: Data?

  init(url: URL, videoURL: URL, caption: String) {
    self.url = url
    self.videoURL = videoURL
    self.caption = caption
    self.gifImage = UIImage.gif(url: url.absoluteString)
    self.gifData = nil
  }

//  init(name: String) {
//    self.gifImage = UIImage.gif(name: name)!
//  }
}

