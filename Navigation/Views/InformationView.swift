//
//  InformationView.swift
//  Navigation
//
//  Created by Samuel Shi on 5/25/21.
//

import SwiftUI
import MapKit

struct InformationView: View {
  let title: String
  @Binding var location: Location?
  @ObservedObject var locationManager: LocationManager
  
  @State private var showMap: Bool = false
  
  var body: some View {
      VStack {
        HStack {
          Text(title).font(.largeTitle)
          Spacer()
          CompassView(rotation: -locationManager.heading)
            .onTapGesture(count: 3) {
              location = nil
            }
        }
        
        Spacer()
        
        HStack {
          Text("\(locationManager.distanceToDestination) miles")
            .font(.title)
          Spacer()
          
          Button(
            action: { showMap.toggle() },
            label: {
              Text("See On Map")
            })
        }
      }
      .padding()
      .sheet(isPresented: $showMap) {
        MapView(location: location!)
      }
  }
}

struct MapView: View {
  @Environment(\.presentationMode) var presentationMode
  
  let location: Location
  
  var body: some View {
    ZStack(alignment: .topTrailing) {
      Map(coordinateRegion: .constant(region),
          annotationItems: [location]) { location in
          MapAnnotation(
            coordinate: coordinate,
            anchorPoint: CGPoint(x: 0.5, y: 0.5),
            content: { annotation })
      }
      .ignoresSafeArea()
      
      Button(action: { presentationMode.wrappedValue.dismiss() }) {
        Text("Done")
          .font(.headline)
          .padding()
      }
    }
  }
  
  var annotation: some View {
    Circle()
      .stroke(Color.blue)
      .frame(width: 44, height: 44)
  }
  
  var coordinate: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
  }
  
  var region: MKCoordinateRegion {
    MKCoordinateRegion(
      center: coordinate,
      span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
  }
}
