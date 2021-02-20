//
//  UIView+Layout.swift
//  InterviewPracticeTest
//
//  Created by Shruti Sharma on 2/17/21.
//

import UIKit

extension UIView {
  
  func addSubviews(_ views: [UIView]) {
    views.forEach { addSubview($0) }
  }
  
  func anchor(top: NSLayoutYAxisAnchor?,
              leading: NSLayoutXAxisAnchor?,
              bottom: NSLayoutYAxisAnchor?,
              trailing: NSLayoutXAxisAnchor?,
              padding: UIEdgeInsets = .zero,
              size: CGSize = .zero) {
    
    translatesAutoresizingMaskIntoConstraints = false
    var constraints = [NSLayoutConstraint]()
    if let top = top {
      constraints.append(topAnchor.constraint(equalTo: top, constant: padding.top))
    }
    if let leading = leading {
      constraints.append(leadingAnchor.constraint(equalTo: leading, constant: padding.left))
    }
    if let bottom = bottom {
      constraints.append(bottomAnchor.constraint(equalTo: bottom, constant: padding.bottom))
    }
    if let trailing = trailing {
      constraints.append(trailingAnchor.constraint(equalTo: trailing, constant: padding.right))
    }
    
    if size.width != 0 {
      constraints.append(widthAnchor.constraint(equalToConstant: size.width))
    }
    if size.height != 0 {
      constraints.append(heightAnchor.constraint(equalToConstant: size.height))
    }
    NSLayoutConstraint.activate(constraints)
  }
  
  func anchorSize(to view: UIView) {
    translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(
      [widthAnchor.constraint(equalTo: view.widthAnchor),
      heightAnchor.constraint(equalTo: view.heightAnchor)])
  }
  
  func fillSuperview() {
    translatesAutoresizingMaskIntoConstraints = false
    anchor(top: superview?.topAnchor,
           leading: superview?.leadingAnchor,
           bottom: superview?.bottomAnchor,
           trailing: superview?.trailingAnchor)
  }
  
  func center(in view: UIView, xAnchor: Bool = true, yAnchor: Bool = true) {
    translatesAutoresizingMaskIntoConstraints = false
    var constraints = [NSLayoutConstraint]()
    if xAnchor { constraints.append(centerXAnchor.constraint(equalTo: view.centerXAnchor)) }
    if yAnchor { constraints.append(centerYAnchor.constraint(equalTo: view.centerYAnchor)) }
    NSLayoutConstraint.activate(constraints)
  }
}

extension UIView {
  func roundWithCornerRadius(_ cornerRadius: CGFloat,
                             borderWidth: CGFloat = 0,
                             borderColor: UIColor = .clear) {
    layer.masksToBounds = true
    layer.cornerRadius = cornerRadius
    layer.borderWidth = borderWidth
    layer.borderColor = borderColor.cgColor
  }
}
