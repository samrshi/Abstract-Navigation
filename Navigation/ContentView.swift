//
//  ContentView.swift
//  Navigation
//
//  Created by Samuel Shi on 5/20/21.
//

import SwiftUI

struct ContentView: View {
  @StateObject var locationManager = LocationManager()
  
  var body: some View {
    ZStack {
      VStack {
        HStack {
          Text("San Francisco").font(.largeTitle)
          Spacer()
          CompassView(rotation: -locationManager.heading)
        }
        Spacer()
        
        HStack {
          Text("\(locationManager.distanceToDestination) miles")
            .font(.title)
          Spacer()
        }
      }
      
      VStack {
        Image(systemName: "arrow.up")
          .font(.system(size: 200))
          .rotationEffect(.degrees(-locationManager.angleToDestination))
      }
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
