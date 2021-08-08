//
//  InformationView.swift
//  Navigation
//
//  Created by Samuel Shi on 5/25/21.
//

import MapKit
import SwiftUI

struct InformationView: View {
  @ObservedObject var manager = MainManager.shared
  @ObservedObject var locationManager: LocationManager

  @State private var showMap: Bool = false
  @State private var showAlert: Bool = false

  var body: some View {
    VStack {
      HStack {
        if let title = manager.selectedLocation?.name {
          Text(title)
            .font(.largeTitle)
        }
        
        Spacer()
        
        Button(action: presentMap) {
          Image(systemName: "map.fill")
            .font(.title2)
            .padding([.vertical, .trailing] ,5)
        }
        
        Button(action: { showAlert.toggle() }) {
          Image(systemName: "xmark")
            .font(.title2)
            .padding(5)
        }
      }

      Spacer()

      HStack {
        Text("\(locationManager.distanceToDestination) \(locationManager.distanceUnit)")
          .font(.largeTitle)

        Spacer()
      }
    }
    .padding()
    .sheet(isPresented: $showMap) {
      MapView(location: manager.selectedLocation!)
    }
    .alert(isPresented: $showAlert) {
      Alert(title: Text("Are you sure?"),
            primaryButton: .cancel(),
            secondaryButton: .default(Text("OK"), action: reset))
    }
  }

  func reset() {
    manager.selectedLocation = nil
  }

  func presentMap() {
    showMap.toggle()
  }
}
