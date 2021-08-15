//
//  SearchResultsView.swift
//  Navigation
//
//  Created by Samuel Shi on 5/29/21.
//

import MapKit
import SwiftUI

struct SearchResultsView: View {
  @ObservedObject var mainManager = MainManager.shared
  @ObservedObject var manager: SearchManager

  var body: some View {
      if !manager.queryFragment.isEmpty {
        Divider()

        SearchStatusView(manager: manager)

        ForEach(manager.mapItems, id: \.id) { mapItem in
          Button {
            print(mapItem.pointOfInterestCategory.toIcon())
            mainManager.selectedLocation = Location(mapItem: mapItem)
          } label: {
            SearchResultView(imageName: mapItem.pointOfInterestCategory.toIcon(), title: mapItem.name ?? "", subtitle: mapItem.placemark.title ?? "")
          }
          .buttonStyle(PlainButtonStyle())
        }
      }
  }
}
