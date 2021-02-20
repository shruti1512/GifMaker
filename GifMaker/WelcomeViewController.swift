//
//  WelcomeViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Shruti Sharma on 2/8/21.
//  Copyright © 2021 Shruti Sharma. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
  
  // MARK: - IBOutlets
  
  @IBOutlet private weak var gifImageView: UIImageView!
  
  // MARK: - View Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let jeremyGif = UIImage.gif(name: "hotlineBling")
    gifImageView.image = jeremyGif
  }
  
  
}
