//
//  GifPreviewViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Shruti Sharma on 2/8/21.
//  Copyright © 2021 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class GifPreviewViewController: UIViewController {
  
  var gif: Gif?
  @IBOutlet private weak var gifImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    gifImageView.image = gif?.gifImage
  }

}
