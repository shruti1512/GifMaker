//
//  GifEditorViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Shruti Sharma on 2/8/21.
//  Copyright © 2021 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class GifEditorViewController: UIViewController {

  @IBOutlet private weak var gifImageView: UIImageView!
  var gifURL: URL?
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    guard let gifURL = gifURL else {
      return
    }
    let gifImage = UIImage.gif(url: gifURL.absoluteString)
    gifImageView.image = gifImage
  }
}
