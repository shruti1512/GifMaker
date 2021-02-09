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
  
  @IBAction func shareGif(_ sender: UIButton) {
    guard let gif = gif, let gifURL = gif.url else { return }
    guard let animatedGif = try? Data(contentsOf: gifURL) else { return }
    
    let shareController = UIActivityViewController(activityItems: [animatedGif],
                                                   applicationActivities: nil)
    shareController.completionWithItemsHandler = { [weak self] activity, completed, items, error in
      guard let self = self else { return }
      if completed {
        self.navigationController?.popToRootViewController(animated: true)
        return
      }
    }
    present(shareController, animated: true)
  }
  
}
