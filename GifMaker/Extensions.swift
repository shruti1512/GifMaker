//
//  Extensions.swift
//  GifMaker
//
//  Created by Shruti Sharma on 2/19/21.
//  Copyright © 2021 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation

extension FileManager {
  static let documentsDirectory = `default`.urls(for: .documentDirectory, in: .userDomainMask).first!
}
