//
//  MapItemView.swift
//  Navigation
//
//  Created by Samuel Shi on 8/15/21.
//

import MapKit
import SwiftUI
import WebKit

struct MapItemView: View {
  @ObservedObject var mainManager = MainManager.shared
  @ObservedObject var searchManager: SearchManager

  var body: some View {
    Group {
      if let mapItem = searchManager.selectedMapItem,
         let title = mapItem.name
      {
        ScrollView {
          VStack(alignment: .leading, spacing: 10) {
            HStack {
              Image(mapItem.pointOfInterestCategory.toIcon())
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)

              Text(title)
                .font(.title2)
                .bold()
                .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.vertical, 10)

            if let address = mapItem.placemark.title {
              NavvySection(header: Text("Address")) {
                Text(address)
                  .fixedSize(horizontal: false, vertical: true)
              }
            }

            if let url = mapItem.url {
              NavvySection(header: Text("Website")) {
                Button {
                  UIApplication.shared.open(url)
                } label: {
                  Text(url.absoluteString)
                    .fixedSize(horizontal: false, vertical: true)
                }
              }
            }

            if let number = mapItem.phoneNumber {
              NavvySection(header: Text("Phone Number")) {
                Button {
                  if let url = URL(string: "tel://" + number.rawPhoneNumber()) {
                    UIApplication.shared.open(url)
                  }
                } label: {
                  Text(number)
                    .fixedSize(horizontal: false, vertical: true)
                }
              }
            }

            VStack {
              Button {
                mainManager.selectedMapItem = mapItem
              } label: {
                HStack {
                  Spacer()
                  Text("Take me there!")
                  Spacer()
                }
                .callToActionButton(background: .blue)
              }
              
              Button {
                searchManager.selectedMapItem = nil
              } label: {
                HStack {
                  Spacer()
                  Text("Cancel")
                  Spacer()
                }
                .callToActionButton(background: Color(.card))
              }
            }
            .padding(.top, 20)
          }
          .padding()
        }
      } else {
        HStack {
          Text("Something went wrong")
          Spacer()
          Button {
            searchManager.selectedMapItem = nil
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
}

struct MapItemView_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35, longitude: -79), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))))

      VStack {
        Spacer()

        HStack {
          Spacer()
          MapItemView(searchManager: SearchManager())
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
