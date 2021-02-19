//
//  ShareGifProtocol.swift
//  GifMaker
//
//  Created by Shruti Sharma on 2/19/21.
//  Copyright © 2021 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

protocol GifShareable {
  func viewController(_ viewController: UIViewController, shareGif gifData: Data)
}

extension GifShareable {
  
  func viewController(_ viewController: UIViewController, shareGif gifData: Data) {
    let shareController = UIActivityViewController(activityItems: [gifData],
                                                   applicationActivities: nil)
    shareController.completionWithItemsHandler = { [weak viewController] activity, completed, items, error in
      guard let viewController = viewController else { return }
      if completed {
        viewController.navigationController?.popToRootViewController(animated: true)
        return
      }
    }
    viewController.present(shareController, animated: true)
  }
}
