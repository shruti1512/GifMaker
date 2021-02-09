//
//  UIViewController+Record.swift
//  GifMaker_Swift_Template
//
//  Created by Shruti Sharma on 2/8/21.
//  Copyright © 2021 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit
import MobileCoreServices

//Regift Constants
let frameCount = 16
let delaytTime: Float = 0.2
let loopCount = 0 // 0 means loop forever

extension  UIViewController {

  @IBAction func launchVideoCamera(sender: AnyObject) {
    
    let pickerController = UIImagePickerController()
    pickerController.sourceType = .camera
    pickerController.mediaTypes = [kUTTypeMovie as String]
    pickerController.allowsEditing = false
    pickerController.delegate = self
    present(pickerController, animated: true)
  }
}

extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
  public func imagePickerController(_ picker: UIImagePickerController,
                                    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
          mediaType == kUTTypeMovie as String else {
      return
    }
    
    if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
      //UISaveVideoAtPathToSavedPhotosAlbum(videoURL.path, nil, nil, nil)
      convertVideoToGif(videoURL)
      dismiss(animated: true)
    }
  }
  
  func convertVideoToGif(_ videoURL: URL) {
    let regift = Regift(sourceFileURL: videoURL, frameCount: frameCount, delayTime: delaytTime, loopCount: loopCount)
    if let gifURL = regift.createGif() {
      let gif = Gif(url: gifURL, videoURL: videoURL, caption: "")
      displayGif(gif)
    }
  }
  
  func displayGif(_ gif: Gif) {
    
    guard let gifEditorVC = storyboard?.instantiateViewController(withIdentifier: "GifEditorViewController")
            as? GifEditorViewController else {
        fatalError("Failed to load GifEditorViewController from storyboard.")
    }
    gifEditorVC.gif = gif
    navigationController?.pushViewController(gifEditorVC, animated: true)
  }

}
