//
//  GifDetailViewController.swift
//  GifMaker
//
//  Created by Shruti Sharma on 2/19/21.
//  Copyright © 2021 Shruti Sharma. All rights reserved.
//

import UIKit

class GifDetailViewController: UIViewController {
  
  // MARK: - IBOutlets

  @IBOutlet private weak var gifImageView: UIImageView!
  @IBOutlet private weak var shareButton: UIButton! {
    didSet { shareButton.roundWithCornerRadius(5) }
  }

  // MARK: - Instance Properties

  public var gif: Gif?
  
  // MARK: - View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    gifImageView.image = gif?.gifImage
  }
  
  // MARK: - IBActions

  @IBAction private func closeView(_ sender: UIButton) {
    dismiss(animated: true)
  }
  
  @IBAction func shareGif(_ sender: UIButton) {
    if let gifData = gif?.gifData { self.viewController(self, shareGif: gifData) }
  }

}

// MARK: - GifShareable

extension GifDetailViewController: GifShareable { }
