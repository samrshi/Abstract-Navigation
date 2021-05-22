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
      Text("N").rotationEffect(.degrees(-rotation))
      
      Spacer()
      
      HStack {
        Text("W").rotationEffect(.degrees(-rotation))
        Spacer()
        Text("E").rotationEffect(.degrees(-rotation))
      }
      
      Spacer()
      
      Text("S").rotationEffect(.degrees(-rotation))
    }
    .font(.headline)
    .frame(width: 60, height: 60)
    .scaleEffect(0.9)
    .background(Circle().stroke(Color.white))
    .rotationEffect(Angle(degrees: rotation))
  }
}

struct CompassView_Previews: PreviewProvider {
  static var previews: some View {
    CompassView(rotation: -35)
  }
}
