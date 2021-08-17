//
//  MapItemView.swift
//  Navigation
//
//  Created by Samuel Shi on 8/15/21.
//

import MapKit
import SwiftUI
import WebKit

let mapItem = MKMapItem.forCurrentLocation()

struct MapItemView: View {
  @ObservedObject var mainManager = MainManager.shared

  var body: some View {
    if let mapItem = mainManager.selectedMapItem {
      VStack(alignment: .leading) {
        Text(mapItem.name ?? "")
          .font(.title2)
          .bold()
          .padding(.bottom, 2)
        
        Text(mapItem.placemark.title ?? "")
          .font(.caption)

        Spacer()

        HStack {
          Button {
            mainManager.selectedMapItem = nil
          } label: {
            HStack {
              Spacer()
              Text("Cancel")
              Spacer()
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding(10)
            .background(Color(.card))
            .cornerRadius(10)
          }
          .padding(.trailing, 2)

          Spacer()

          Button {
            mainManager.selectedMapItem = mapItem
          } label: {
            HStack {
              Spacer()
              Text("Take me there!")
              Spacer()
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding(10)
            .background(Color.blue)
            .cornerRadius(10)
          }
          .padding(.leading, 2)
        }
        .padding(.top, 40)
      }
      .padding()
    } else {
      HStack {
        Text("Something went wrong")
        Spacer()
        Button {
          mainManager.selectedMapItem = nil
        } label: {
          Image(systemName: "xmark")
          .font(.headline)
          .foregroundColor(.white)
          .padding(10)
          .background(Color(.card))
          .clipShape(Circle())
        }
      }
      .padding()
    }
  }
}

struct MapItemView_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35, longitude: -79), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))))

      VStack {
        Spacer()

        HStack {
          Spacer()
          MapItemView()
          Spacer()
        }
        .frame(height: UIScreen.main.bounds.height / 2)
        .background(Color(.background))
        .cornerRadius(16)
      }
    }
    .ignoresSafeArea()
    .preferredColorScheme(.dark)
  }
}
