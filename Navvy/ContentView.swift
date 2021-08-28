//
//  ContentView.swift
//  Navigation
//
//  Created by Samuel Shi on 5/20/21.
//

import CoreLocation
import MapKit
import SwiftUI

struct ContentView: View {
  @ObservedObject var manager = MainManager.shared
  @AppStorage("showOnboarding") var showOnboarding: Bool = true

  var body: some View {
    if showOnboarding {
      OnboardingView(image: "navvy-ill",
                     title: "Enable Location Permissions",
                     description: "Navvy uses your location to help you search\nfor nearby locations and to show how to\nget to your destination.",
                     buttonText: "Okay, I understand!",
                     action: goToApp)
    } else {
      MainViewController.View()
        .onAppear {
          LocationManager.shared = LocationManager()
        }
        .ignoresSafeArea()
    }
  }
  
  func goToApp() {
    showOnboarding = false
    LocationManager.shared = LocationManager()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
