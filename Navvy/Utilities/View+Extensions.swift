//
//  View+Extensions.swift
//  Navigation
//
//  Created by Samuel Shi on 8/8/21.
//

import SwiftUI

extension View {
  func fullscreenBackground<Content: View>(_ background: Content) -> some View {
    return ZStack {
      background.ignoresSafeArea()

      self
    }
  }

  func myCard() -> some View {
    self
      .padding()
      .background(Color(.card))
      .cornerRadius(10)
  }
}

