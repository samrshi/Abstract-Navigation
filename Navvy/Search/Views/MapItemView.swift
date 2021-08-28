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
            NavvySection(header: headerView(string: "Address")) {
              Text(address)
                .fixedSize(horizontal: false, vertical: true)
                .font(.system(size: 12))
            }
          }

          if let url = mapItem.url {
            NavvySection(header: headerView(string: "Website")) {
              Button {
                UIApplication.shared.open(url)
              } label: {
                Text(url.absoluteString)
                  .fixedSize(horizontal: false, vertical: true)
                  .font(.system(size: 12))
              }
            }
          }

          if let number = mapItem.phoneNumber {
            NavvySection(header: headerView(string: "Phone Number")) {
              Button {
                if let url = URL(string: "tel://" + number.rawPhoneNumber()) {
                  UIApplication.shared.open(url)
                }
              } label: {
                Text(number)
                  .fixedSize(horizontal: false, vertical: true)
                  .font(.system(size: 12))
              }
            }
          }

          HStack {
            Button {
              searchManager.selectedMapItem = nil
            } label: {
              HStack {
                Spacer()
                Text("Cancel")
                Spacer()
              }
              .font(.headline)
              .foregroundColor(.primary)
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
          .padding(.top, 20)
        }
        .padding()
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

  func headerView(string: String) -> some View {
    Text(string).font(.system(size: 12))
  }

  func sectionContentView<Content: View>(@ViewBuilder content: () -> Content) -> some View {
    content()
      .font(.system(size: 15))
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
