//
//  NavigationView.swift
//  Navigation
//
//  Created by Samuel Shi on 5/25/21.
//

import SwiftUI

struct NavigationScreen: View {
  @StateObject var locationManager: NavigationManager
  @ObservedObject var manager: MainManager
  @State private var showMap = false

  var body: some View {
    VStack {
      header

      Spacer()

      Image(systemName: "arrow.up")
        .font(.system(size: 200))
        .rotationEffect(.degrees(-locationManager.angleToDestination))
        .accessibilityLabel(Text(locationManager.accessibilityHeading))

      Spacer()

      HStack {
        Text("\(locationManager.distanceToDestination) \(locationManager.distanceUnit)")
          .font(.largeTitle)

        Spacer()
      }
    }
    .padding()
    .sheet(isPresented: $showMap) { MapView(mapItem: manager.selectedMapItem!) }
    .fullScreenCover(isPresented: $locationManager.showErrorScreen) { onboardingView }
    .fullscreenBackground(Color(.background))
  }
  
  var header: some View {
    HStack(alignment: .top) {
      if let title = manager.selectedMapItem?.name {
        Text(title)
          .font(.largeTitle)
      }

      Spacer()

      Button(action: presentMap) {
        Image(systemName: "map.fill")
          .foregroundColor(.white)
          .font(.title2)
          .padding([.vertical, .trailing], 5)
      }

      Button(action: reset) {
        Image(systemName: "xmark")
          .foregroundColor(.white)
          .font(.title2)
          .padding(5)
      }
    }
  }

  var onboardingView: some View {
    OnboardingView(image: "navvy-ill",
                   title: "Enable Location Permissions",
                   description: "Navvy uses your location to help you search\nfor nearby locations and to show how to\nget to your destination.\n\nYou can turn this on in Settings.",
                   buttonText: "Take me to Settings!",
                   action: showSettings)
  }

  func showSettings() {
    locationManager.showErrorScreen = false

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      manager.selectedMapItem = nil
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
      }
    }
  }

  func reset() {
    manager.selectedMapItem = nil
  }

  func presentMap() {
    showMap.toggle()
  }

  init() {
    let manager = MainManager.shared
    guard let mapItem = manager.selectedMapItem else { fatalError("No Location Present") }

    self.manager = MainManager.shared
    self._locationManager = StateObject(wrappedValue: NavigationManager(mapItem: mapItem))
  }
}

struct NavigationScreen_Previews: PreviewProvider {
  static var previews: some View {
    NavigationScreen()
  }
}
