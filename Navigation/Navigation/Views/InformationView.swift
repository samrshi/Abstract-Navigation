//
//  InformationView.swift
//  Navigation
//
//  Created by Samuel Shi on 5/25/21.
//

import MapKit
import SwiftUI

struct InformationView: View {
  let title: String
  @Binding var location: Location?
  @ObservedObject var locationManager: LocationManager

  @State private var showMap: Bool = false

  var body: some View {
    VStack {
      HStack {
        Text(title)
          .font(.largeTitle)
        Spacer()
        CompassView(rotation: -locationManager.heading)
          .onTapGesture(count: 3, perform: reset)
      }

      Spacer()

      HStack {
        Text("\(locationManager.distanceToDestination) miles")
          .font(.title)

        Spacer()

        Button(action: presentMap) {
          Text("Show On Map")
        }
      }
    }
    .padding()
    .sheet(isPresented: $showMap) {
      MapView(location: location!)
    }
  }

  func reset() {
    location = nil
  }

  func presentMap() {
    showMap.toggle()
  }
}
