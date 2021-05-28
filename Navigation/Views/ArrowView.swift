//
//  ArrowView.swift
//  Navigation
//
//  Created by Samuel Shi on 5/25/21.
//

import SwiftUI

struct ArrowView: View {
  let rotation: Double
  
  var body: some View {
    Image(systemName: "arrow.up")
      .font(.system(size: 200))
      .rotationEffect(.degrees(rotation))
  }
}

struct ArrowView_Previews: PreviewProvider {
  static var previews: some View {
    ArrowView(rotation: 0)
  }
}
