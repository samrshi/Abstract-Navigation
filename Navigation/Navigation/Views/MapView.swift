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
  
  let location: Location
  let vm: MapVM
  
  init(location: Location) {
    self.location = location
    vm = MapVM(location: location)
    _region = State(initialValue: vm.region)
  }
  
  var body: some View {
    ZStack(alignment: .top) {
      Map(coordinateRegion: $region,
          interactionModes: .all,
          showsUserLocation: true,
          userTrackingMode: nil,
          annotationItems: [location]) { _ in
        MapMarker(coordinate: vm.coordinate)
      }
      .ignoresSafeArea()
      .animation(.easeInOut)
      
      HStack {
        Button(action: { region = vm.region }) {
          Image("map-center")
            .renderingMode(.template)
            .resizable()
            .foregroundColor(.blue.opacity(0.8))
            .frame(width: 35, height: 35)
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

struct MapVM {
  let coordinate: CLLocationCoordinate2D
  let region: MKCoordinateRegion
  
  init(location: Location) {
    coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    region = MKCoordinateRegion(
      center: coordinate,
      span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
  }
}
