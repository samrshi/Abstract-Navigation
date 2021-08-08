//
//  UIView+AddAndPinSubview.swift
//  Navigation
//
//  Created by Samuel Shi on 8/8/21.
//

import UIKit

extension UIView {
  func addAndPinSubview(view: UIView,
                        topPadding: CGFloat? = nil,
                        leadingPadding: CGFloat? = nil,
                        trailingPadding: CGFloat? = nil,
                        bottomPadding: CGFloat? = nil) {
    self.addSubview(view)
    NSLayoutConstraint.activate([
      view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingPadding ?? 0),
      view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: trailingPadding ?? 0),
      view.topAnchor.constraint(equalTo: self.topAnchor, constant: topPadding ?? 0),
      view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: bottomPadding ?? 0)
    ])
  }
}
