//
//  NavigationView.swift
//  Navigation
//
//  Created by Samuel Shi on 5/25/21.
//

import SwiftUI

struct NavigationScreen: View {
  @StateObject var locationManager: LocationManager
  @ObservedObject var manager: MainManager

  init() {
    let manager = MainManager.shared
    guard let location = manager.selectedLocation else { fatalError("No Location Present") }

    self.manager = MainManager.shared
    self._locationManager = StateObject(wrappedValue: LocationManager(location: location))
  }

  var body: some View {
    ZStack {
      ArrowView(rotation: -locationManager.angleToDestination)

      InformationView(locationManager: locationManager)
    }
  }
}

struct NavigationScreen_Previews: PreviewProvider {
  static var previews: some View {
    NavigationScreen()
  }
}
