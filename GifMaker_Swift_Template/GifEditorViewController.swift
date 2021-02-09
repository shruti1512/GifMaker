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
//  @IBOutlet private weak var captionTextField: UITextField! {
//    didSet {
//      captionTextField.delegate = self
//    }
//  }
  
  var gif: Gif?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    subscribeToKeyboardNotifications()
    gifImageView.image = gif?.gifImage
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unsubscribeFromKeyboardNotifications()
  }
  
//  @IBAction func presentPreview(_ sender: UIButton) {
//
//    guard let gifPreviewVC = storyboard?.instantiateViewController(withIdentifier: "GifPreviewViewController")
//            as? GifPreviewViewController else { return }
//    guard let gif = gif, gif.videoURL != nil else { return }
//    gif.caption = captionTextField.text
//
//    let regift = Regift(sourceFileURL: gif.videoURL!,
//                        destinationFileURL: nil,
//                        frameCount: frameCount,
//                        delayTime: delaytTime,
//                        loopCount: loopCount)
//    let captionFont = captionTextField.font;
//    guard let gifURL = regift.createGif(captionTextField.text, font: captionFont) else { return  }
//
//    let newGif = Gif(url: gifURL, videoURL: gif.videoURL!, caption: captionTextField.text!)
//    gifPreviewVC.gif = newGif
//    navigationController?.present(gifPreviewVC, animated: true, completion: nil)
//
//  }
  
  // MARK: - Observe and respond to keyboard notifications
  
  func subscribeToKeyboardNotifications() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillShow),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillHide),
                                           name: UIResponder.keyboardDidHideNotification,
                                           object: nil)
  }
  
  func unsubscribeFromKeyboardNotifications() {
    NotificationCenter.default.removeObserver(self,
                                              name: UIResponder.keyboardWillShowNotification,
                                              object: nil)
    NotificationCenter.default.removeObserver(self,
                                              name: UIResponder.keyboardDidHideNotification,
                                              object: nil)
  }
  
  @objc func keyboardWillShow(notification: NSNotification) {
    if view.frame.origin.y >= 0 {
      view.frame.origin.y -= getKeyboardHeight(notification: notification)
    }
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    if (view.frame.origin.y < 0) {
      view.frame.origin.y += getKeyboardHeight(notification: notification)
    }
  }

  func getKeyboardHeight(notification: NSNotification) -> CGFloat {
    let userInfo = notification.userInfo
    let keyboardFrameEnd = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
    let keyboardFrameEndRect = keyboardFrameEnd?.cgRectValue
    return keyboardFrameEndRect?.size.height ?? 0
  }

}

//// MARK: - UITextFieldDelegate
//
//extension GifEditorViewController: UITextFieldDelegate {
//  func textFieldDidBeginEditing(_ textField: UITextField) {
//    textField.placeholder = ""
//  }
//  
//  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//    textField.resignFirstResponder()
//    return true
//  }
//}
