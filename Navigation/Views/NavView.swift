//
//  NavigationView.swift
//  Navigation
//
//  Created by Samuel Shi on 5/25/21.
//

import SwiftUI

struct NavView: View {
  @StateObject var locationManager: LocationManager
  @Binding var location: Location?
  
  init(location: Binding<Location?>) {
    guard location.wrappedValue != nil else { fatalError("No Location Present") }
    
    self._location = location
    self._locationManager = StateObject(wrappedValue: LocationManager(location: location.wrappedValue!))
  }
  
  var body: some View {
    ZStack {
      if let title = location?.name {
        ArrowView(rotation: -locationManager.angleToDestination)
        
        InformationView(
          title: title,
          location: $location,
          locationManager: locationManager)
      }
    }
  }
}
