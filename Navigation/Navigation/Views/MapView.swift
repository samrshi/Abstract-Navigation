//
//  MapView.swift
//  Navigation
//
//  Created by Samuel Shi on 5/29/21.
//

import MapKit
import SwiftUI

struct MapView: View {
  @Environment(\.presentationMode) var presentationMode
  @State private var region: MKCoordinateRegion
  
  let mapItem: MKMapItem
  let vm: MapViewModel
  
  init(mapItem: MKMapItem) {
    self.mapItem = mapItem
    vm = MapViewModel(mapItem: mapItem)
    _region = State(initialValue: vm.region)
  }
  
  var body: some View {
    ZStack(alignment: .top) {
      Map(coordinateRegion: $region,
          interactionModes: .all,
          showsUserLocation: true,
          userTrackingMode: nil,
          annotationItems: [mapItem]) { _ in
        MapMarker(coordinate: vm.coordinate)
      }
      .ignoresSafeArea()
      .animation(.easeInOut)
      
      HStack {
        Button(action: { region = vm.region }) {
          Image(systemName: "mappin.circle.fill")
            .font(.headline)
            .padding(10)
            .foregroundColor(.white)
            .background(Color.blue.opacity(0.8))
            .cornerRadius(10)
            .padding(10)
        }
        
        Spacer()
        
        Button(action: { presentationMode.wrappedValue.dismiss() }) {
          Text("Done")
            .font(.headline)
            .padding(10)
            .foregroundColor(.white)
            .background(Color.blue.opacity(0.8))
            .cornerRadius(10)
            .padding(10)
        }
      }
    }
  }
}

struct MapViewModel {
  let coordinate: CLLocationCoordinate2D
  let region: MKCoordinateRegion
  
  init(mapItem: MKMapItem) {
    coordinate = mapItem.placemark.coordinate
    region = MKCoordinateRegion(
      center: coordinate,
      span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
  }
}
