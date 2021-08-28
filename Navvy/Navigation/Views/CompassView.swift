//
//  CompassView.swift
//  Navigation
//
//  Created by Samuel Shi on 5/21/21.
//

import SwiftUI

struct CompassView: View {
  let rotation: Double

  var body: some View {
    VStack {
      Text("N")
        .padding(.bottom, 10)
      
      Image(systemName: "arrow.up")
        .font(.system(size: 22, weight: .bold, design: .default))
    }
    .rotationEffect(Angle(degrees: rotation))
  }
}

struct CompassView_Previews: PreviewProvider {
  static var previews: some View {
    CompassView(rotation: -35)
  }
}
