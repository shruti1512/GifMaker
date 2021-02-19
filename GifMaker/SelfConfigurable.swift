//
//  SelfConfigurable.swift
//  InterviewPracticeTest
//
//  Created by Shruti Sharma on 2/17/21.
//

import Foundation

protocol SelfConfigurable {
  associatedtype T
  static var reuseIdentifier: String { get }
  func configure(with data: T)
}
