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

  init() {
    let manager = MainManager.shared
    guard let mapItem = manager.selectedMapItem else { fatalError("No Location Present") }

    self.manager = MainManager.shared
    self._locationManager = StateObject(wrappedValue: NavigationManager(mapItem: mapItem))
  }

  var body: some View {
    ZStack {
      Image(systemName: "arrow.up")
        .font(.system(size: 200))
        .rotationEffect(.degrees(-locationManager.angleToDestination))
        .accessibilityLabel(Text(locationManager.accessibilityHeading))

      InformationView(locationManager: locationManager)
    }
    .fullScreenCover(isPresented: $locationManager.showErrorScreen) { onboardingView }
    .fullscreenBackground(Color(.background))
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
}

struct NavigationScreen_Previews: PreviewProvider {
  static var previews: some View {
    NavigationScreen()
  }
}
