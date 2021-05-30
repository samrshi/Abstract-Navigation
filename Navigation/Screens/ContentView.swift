//
//  ContentView.swift
//  Navigation
//
//  Created by Samuel Shi on 5/20/21.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
  @State private var location: Location?
  
  var body: some View {
    if location != nil {
      NavigationScreen(location: $location)
    } else {
      SearchScreen(location: $location)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
