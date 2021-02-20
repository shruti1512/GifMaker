//
//  Gif.swift
//  GifMaker_Swift_Template
//
//  Created by Shruti Sharma on 2/8/21.
//  Copyright © 2021 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

struct Gif {
  let gifURL: URL
  let videoURL: URL
  var caption: String?
  let gifImage: UIImage?
  var gifData: Data?
  let identifier = UUID().uuidString

  init(gifURL: URL, videoURL: URL, caption: String) {
    self.gifURL = gifURL
    self.videoURL = videoURL
    self.caption = caption
    self.gifImage = UIImage.gif(url: gifURL.absoluteString)
    self.gifData = nil
  }
}

extension Gif: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }
  static func ==(lhs: Gif, rhs: Gif) -> Bool {
    return lhs.identifier == rhs.identifier
  }
}

extension Gif: Codable {
  enum CodingKeys: String, CodingKey {
    case gifURL
    case videoURL
    case caption
    case gifImage
    case gifData
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    gifURL = try container.decode(URL.self, forKey: .gifURL)
    videoURL = try container.decode(URL.self, forKey: .videoURL)
    caption = try container.decode(String.self, forKey: .caption)
    gifData = try container.decode(Data.self, forKey: .gifData)
    let imageData = try container.decode(Data.self, forKey: .gifImage)
    gifImage = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(imageData) as? UIImage ?? nil
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(gifURL, forKey: .gifURL)
    try container.encode(videoURL, forKey: .videoURL)
    try container.encode(caption, forKey: .caption)
    try container.encode(gifData, forKey: .gifData)
    guard let gifImage = gifImage else { return }
    let imageData = try NSKeyedArchiver.archivedData(withRootObject: gifImage, requiringSecureCoding: false)
    try container.encode(imageData, forKey: .gifImage)
  }
}
