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
  
  let location: Location
  
  var body: some View {
    ZStack(alignment: .topTrailing) {
      Map(coordinateRegion: .constant(region),
          annotationItems: [location]) { _ in
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
