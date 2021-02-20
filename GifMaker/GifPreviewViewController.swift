//
//  GifPreviewViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Shruti Sharma on 2/8/21.
//  Copyright © 2021 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

protocol PreviewViewControllerDelegate: class {
  func previewViewController(_ previewVC: GifPreviewViewController, didSaveGif gif: Gif)
}

class GifPreviewViewController: UIViewController {
  
  var gif: Gif?
  weak var delegate: PreviewViewControllerDelegate?
  @IBOutlet private weak var gifImageView: UIImageView!
  @IBOutlet private weak var createAndSaveButton: UIButton! {
    didSet { createAndSaveButton.roundWithCornerRadius(5) }
  }
  @IBOutlet private weak var shareButton: UIButton! {
    didSet {
      let borderColor = UIColor(red: 255/255, green: 65/255, blue: 112/255, alpha: 1)
      shareButton.roundWithCornerRadius(5, borderWidth: 1.0,
                                                borderColor: borderColor)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    gifImageView.image = gif?.gifImage
  }
  
  @IBAction func shareGif(_ sender: UIButton) {
    guard let gif = gif else { return }
    do {
      let gifData = try Data(contentsOf: gif.gifURL)
      self.viewController(self, shareGif: gifData)
    }catch (let error) {
      print("Failed to read gif from url: \(gif.gifURL). Error: \(error.localizedDescription)")
    }
  }
  
  @IBAction private func createAndSave(_ sender: UIButton) {
    if let gif = gif {
      delegate?.previewViewController(self, didSaveGif: gif)
    }
    navigationController?.popToRootViewController(animated: true)
  }
  
}

extension GifPreviewViewController: GifShareable { }
