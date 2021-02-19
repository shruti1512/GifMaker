//
//  WelcomeViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Shruti Sharma on 2/8/21.
//  Copyright © 2021 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
  
  @IBOutlet private weak var gifImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // An animated UIImage
    let jeremyGif = UIImage.gif(name: "hotlineBling")
    gifImageView.image = jeremyGif
  }
  
  
}
