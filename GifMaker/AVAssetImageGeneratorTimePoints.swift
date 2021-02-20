//
//  AVAssetImageGeneratorTimePoints.swift
//  GifMaker_ObjC
//
//  Created by Shruti Sharma on 02/08/21.
//  Copyright © 2021 Shruti Sharma. All rights reserved.
//

import AVFoundation

public extension AVAssetImageGenerator {
    func generateCGImagesAsynchronouslyForTimePoints(_ timePoints: [TimePoint], completionHandler: @escaping AVAssetImageGeneratorCompletionHandler) {
        let times = timePoints.map {timePoint in
            return NSValue(time: timePoint)
        }
        self.generateCGImagesAsynchronously(forTimes: times, completionHandler: completionHandler)
    }
}
