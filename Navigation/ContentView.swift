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

  var body: some View {
    MainViewController.View()
      .ignoresSafeArea()
      .fullScreenCover(isPresented: .constant(manager.selectedLocation != nil)) {
        NavigationScreen()
      }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
