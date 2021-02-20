//
//  UIViewController+Record.swift
//  GifMaker_Swift_Template
//
//  Created by Shruti Sharma on 2/8/21.
//  Copyright © 2021 Shruti Sharma. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation

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
      let duration = start == nil ? nil : NSNumber(value: end!.floatValue - start!.floatValue)
      cropVideoToSquare(videoURL: videoURL, start: start, duration: duration)
    }
  }
  
  // MARK: - Show GIF methods
  
  func cropVideoToSquare(videoURL: URL, start: NSNumber?, duration: NSNumber?) {

      // Initialize AVAsset and AVAssetTrack
      let videoAsset = AVAsset(url:videoURL)
      let videoTrack = videoAsset.tracks(withMediaType: AVMediaType.video)[0]

      // Initialize video composition and set properties
      let videoComposition = AVMutableVideoComposition()
      videoComposition.renderSize = CGSize(width: videoTrack.naturalSize.height, height: videoTrack.naturalSize.height)
      videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)

      // Initialize instruction and set time range
      let instruction = AVMutableVideoCompositionInstruction()
      instruction.timeRange = CMTimeRangeMake(start: .zero,
                                            duration: CMTimeMakeWithSeconds(60, preferredTimescale: 30) )

      //Center the cropped video
      let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack:videoTrack)
      let firstTransform = CGAffineTransform(translationX: videoTrack.naturalSize.height,
                                             y: -(videoTrack.naturalSize.width - videoTrack.naturalSize.height)/2.0)

      //Rotate 90 degrees to portrait
      let secondTransform = firstTransform.rotated(by: .pi / 2);
      let finalTransform = secondTransform;
      transformer.setTransform(finalTransform, at:CMTime.zero)
      instruction.layerInstructions = [transformer]
      videoComposition.instructions = [instruction]

      // Export the square video
      let exporter = AVAssetExportSession(asset:videoAsset, presetName:AVAssetExportPresetHighestQuality)!
      exporter.videoComposition = videoComposition
      let path = createPath()
      exporter.outputURL = URL(fileURLWithPath: path)
      exporter.outputFileType = AVFileType.mov

      exporter.exportAsynchronously {
      let squareURL = exporter.outputURL!
        self.convertVideoToGif(squareURL, startTime: start, duration: duration)
      }
  }

//  func cropVideoToSquare(videoURL: URL, start: NSNumber?, duration: NSNumber?) {
//
//      // Random Video Name
//      var randomVideoName : String = String(Int.random(in: 10000 ..< 99999))
//      randomVideoName.append(".mov")
//
//      // output file
//      let docFolder = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last
//      let outputPath = URL(fileURLWithPath: docFolder ?? "").appendingPathComponent(randomVideoName)
//      if FileManager.default.fileExists(atPath: outputPath.absoluteString) {
//          do {
//              try FileManager.default.removeItem(atPath: outputPath.absoluteString)
//          } catch {
//          }
//      }
//
//      // input file
//      let asset = AVAsset(url: videoURL)
//
//      let composition = AVMutableComposition()
//      composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
//
//      // input clip
//      let clipVideoTrack: AVAssetTrack = asset.tracks(withMediaType: .video)[0]
//
//      // make it square
//      let videoComposition = AVMutableVideoComposition()
//      videoComposition.renderSize = CGSize(width: clipVideoTrack.naturalSize.height, height: clipVideoTrack.naturalSize.height)
//      videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
//
//      let instruction = AVMutableVideoCompositionInstruction()
//      instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: CMTimeMakeWithSeconds(60, preferredTimescale: 30))
//
//      // rotate to portrait
//      let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: clipVideoTrack)
//      let t1 = CGAffineTransform(translationX: clipVideoTrack.naturalSize.height, y: -(clipVideoTrack.naturalSize.width - clipVideoTrack.naturalSize.height) / 2)
//      let t2: CGAffineTransform = t1.rotated(by: CGFloat(Double.pi/2))
//
//      let finalTransform: CGAffineTransform = t2
//      transformer.setTransform(finalTransform, at: .zero)
//      instruction.layerInstructions = [transformer]
//      videoComposition.instructions = [instruction]
//
//      // export
//      let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)
//      exporter?.videoComposition = videoComposition
//      exporter?.outputURL = outputPath
//      exporter?.outputFileType = .mov
//
//      exporter?.exportAsynchronously(completionHandler: {
//          if let squareURL = exporter?.outputURL {
//          self.convertVideoToGif(videoURL:squareURL, start: nil, duration: nil)
//          print("Exporting done!")
//          }
//      })
//  }

//  func cropVideoToSquare(videoURL: URL, start: NSNumber?, duration: NSNumber?) {
//
//    //Create the AVAsset and AVAssetTrack
//    let videoAsset = AVAsset(url: videoURL)
//    let videoTrack = videoAsset.tracks(withMediaType: .video)[0]
//
//    //Crop to square
//    let videoComposition = AVMutableVideoComposition()
//    videoComposition.renderSize = CGSize(width: videoTrack.naturalSize.height, height: videoTrack.naturalSize.height)
//    videoComposition.frameDuration = CMTime(seconds: 1, preferredTimescale: 30)
//
//    let instruction = AVMutableVideoCompositionInstruction()
//    instruction.timeRange = CMTimeRange(start: .zero,
//                                        end: CMTimeMakeWithSeconds(60, preferredTimescale: 30))
//
//    //rotate to portrait
//    let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
//    let t1 = CGAffineTransform(translationX: videoTrack.naturalSize.height, y: -(videoTrack.naturalSize.width - videoTrack.naturalSize.height)/2)
//    let t2 = t1.rotated(by: .pi / 2)
//    let  finalTransform = t2
//    transformer.setTransform(finalTransform, at: .zero)
//    instruction.layerInstructions = [transformer]
//    videoComposition.instructions = [instruction]
//
//    //export
//    if let exporter = AVAssetExportSession(asset: videoAsset,
//                                           presetName: AVAssetExportPresetHighestQuality) {
//      exporter.videoComposition = videoComposition
//      let path = createPath()
//      exporter.outputURL = URL(fileURLWithPath: path)
//      exporter.outputFileType = AVFileType.mov
//
//      exporter.exportAsynchronously(completionHandler: {
//        if let croppedURL = exporter.outputURL {
//          self.convertVideoToGif(croppedURL, startTime: start, duration: duration)
//          print("Exporting done!")
//        }
//      })
//    }
//  }
  
  func createPath() -> String {
    let fileManager = FileManager.default
    var outputURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("output")
    try? fileManager.createDirectory(atPath: outputURL.path, withIntermediateDirectories: true, attributes: nil)
    outputURL = outputURL.appendingPathComponent("output.mov")
    
    // Remove Existing File
    try? fileManager.removeItem(atPath: outputURL.path)
    return outputURL.path
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
      let gif = Gif(gifURL: gifURL, videoURL: videoURL, caption: "")
      displayGif(gif)
    }
  }
  
  func displayGif(_ gif: Gif) {
    DispatchQueue.main.async { [weak self] in
      guard let gifEditorVC = self?.storyboard?.instantiateViewController(withIdentifier: "GifEditorViewController")
              as? GifEditorViewController else {
        fatalError("Failed to load GifEditorViewController from storyboard.")
      }
      gifEditorVC.gif = gif
      self?.navigationController?.pushViewController(gifEditorVC, animated: true)
    }
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
