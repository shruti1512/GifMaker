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
      let start: NSNumber? = info[UIImagePickerController.InfoKey(rawValue: "_UIImagePickerControllerVideoEditingStart")]
        as? NSNumber
      let end: NSNumber? = info[UIImagePickerController.InfoKey(rawValue: "_UIImagePickerControllerVideoEditingEnd")]
        as? NSNumber
      var duration: NSNumber?
      if let start = start {
        duration = NSNumber(value: end!.floatValue - start.floatValue)
      }
      convertVideoToGif(videoURL, startTime: start, duration: duration)
    }
  }
  
  func convertVideoToGif(_ videoURL: URL, startTime: NSNumber?, duration: NSNumber?) {
    DispatchQueue.main.async {
      self.dismiss(animated: true, completion: nil)
    }
    let regift: Regift?
    if let startTime = startTime, let duration = duration {
      //Trimmed
      regift = Regift(sourceFileURL: videoURL,
                      destinationFileURL: nil,
                      startTime: startTime.floatValue,
                      duration: duration.floatValue,
                      frameRate: frameCount,
                      loopCount: loopCount)
    }
    else {
      //Untrimmed
      regift = Regift(sourceFileURL: videoURL,
                      destinationFileURL: nil,
                      frameCount: frameCount,
                      delayTime: delaytTime,
                      loopCount: loopCount)
    }
    if let gifURL = regift?.createGif() {
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
  
  func launchPhotoLibrary() {
    let imagePickerController = pickerControllerWithSource(.photoLibrary)
    present(imagePickerController, animated: true)
  }
  
  func launchCamera() {
    let imagePickerController = pickerControllerWithSource(.camera)
    present(imagePickerController, animated: true)
  }
  
  func pickerControllerWithSource(_ source: UIImagePickerController.SourceType) -> UIImagePickerController {
    let pickerController = UIImagePickerController()
    pickerController.sourceType = source
    pickerController.mediaTypes = [kUTTypeMovie as String]
    pickerController.allowsEditing = true
    pickerController.delegate = self
    return pickerController
  }
  
  @IBAction func presentVideoOptions() {
    if !UIImagePickerController.isSourceTypeAvailable(.camera) {
      launchPhotoLibrary()
    }
    else {
      let actionSheet = UIAlertController(title: "Create new GIF",
                                          message: nil,
                                          preferredStyle: .actionSheet)
      let recordVideo = UIAlertAction(title: "Record a video",
                                      style: .default) { [weak self] action in
        self?.launchCamera()
      }
      
      let chooseFromExisting = UIAlertAction(title: "Choose from Existing",
                                             style: .default) { [weak self] (action) in
        self?.launchPhotoLibrary()
      }
      
      let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      
      actionSheet.addAction(recordVideo)
      actionSheet.addAction(chooseFromExisting)
      actionSheet.addAction(cancel)
      
      present(actionSheet, animated: true)
      actionSheet.view.tintColor = .systemPink
    }
  }
  
}
