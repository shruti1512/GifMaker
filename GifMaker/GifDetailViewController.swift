//
//  GifDetailViewController.swift
//  GifMaker
//
//  Created by Shruti Sharma on 2/19/21.
//  Copyright © 2021 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class GifDetailViewController: UIViewController {
  
  @IBOutlet private weak var gifImageView: UIImageView!
  
  @IBOutlet private weak var shareButton: UIButton! {
    didSet {
      shareButton.roundWithCornerRadius(5)
    }
  }

  public var gif: Gif?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    gifImageView.image = gif?.gifImage
  }
  
  @IBAction private func closeView(_ sender: UIButton) {
    dismiss(animated: true)
  }
  
  @IBAction func shareGif(_ sender: UIButton) {
    if let gifData = gif?.gifData { self.viewController(self, shareGif: gifData) }
  }

}

extension GifDetailViewController: GifShareable { }
