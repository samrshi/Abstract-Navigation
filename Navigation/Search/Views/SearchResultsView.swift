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
    Group {
      if !manager.queryFragment.isEmpty {
        Divider()

        SearchStatusView(manager: manager)

        if !manager.searchResults.isEmpty {
          Button(action: manager.getMapItems) {
            Text("Search for \"\(manager.queryFragment)\" on map...")
                .bold()
                .font(.subheadline)
          }
        }
        ForEach(manager.searchResults, id: \.self) { result in
          Button(action: { geocode(result) }) {
            SearchResultView(result: result)
          }
          .buttonStyle(PlainButtonStyle())
        }
      }
    }
  }

  func geocode(_ completionResult: MKLocalSearchCompletion) {
    LocalSearchPublishers.geocode(completionResult: completionResult, region: manager.region)
      .compactMap { Location(mapItem: $0.first) }
      .receive(on: DispatchQueue.main)
      .sink { _ in } receiveValue: { location in
        mainManager.selectedLocation = location
      }
      .store(in: &manager.cancellables)
  }
}
