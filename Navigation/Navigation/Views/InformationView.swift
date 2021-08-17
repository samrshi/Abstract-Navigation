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
  @ObservedObject var locationManager: NavigationManager
  @State private var showMap: Bool = false

  var body: some View {
    VStack {
      HStack(alignment: .top) {
        if let title = manager.selectedMapItem?.name {
          Text(title)
            .font(.largeTitle)
        }
        
        Spacer()
        
        Button(action: presentMap) {
          Image(systemName: "map.fill")
            .font(.title2)
            .padding([.vertical, .trailing] ,5)
        }
        
        Button(action: reset) {
          Image(systemName: "xmark")
            .font(.title2)
            .padding(5)
        }
      }
      .buttonStyle(PlainButtonStyle())

      Spacer()

      HStack {
        Text("\(locationManager.distanceToDestination) \(locationManager.distanceUnit)")
          .font(.largeTitle)

        Spacer()
      }
    }
    .padding()
    .sheet(isPresented: $showMap) {
      MapView(mapItem: manager.selectedMapItem!)
    }
  }

  func reset() {
    manager.selectedMapItem = nil
  }

  func presentMap() {
    showMap.toggle()
  }
}
