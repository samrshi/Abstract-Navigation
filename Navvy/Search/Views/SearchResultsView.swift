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

      if !manager.searchResults.isEmpty {
        Button {
          manager.fetchLocations()
        } label: {
          Text("Show \"\(manager.queryFragment)\" results on map.")
            .accessibilityHidden(true)
            .padding(.vertical, 3)
        }
        
        Divider()
        
        ForEach(Array(manager.searchResults.enumerated()), id: \.1) { index, result in
          VStack(alignment: .leading) {
            Button {
              if !mainManager.isScrolling {
                mainManager.dismissKeyboard()
                NotificationCenter.default.post(name: .keyboardHiddenByUser, object: nil)
                manager.selectedCompletion = result
              }
            } label: {
              SearchResultView(title: result.title, subtitle: result.subtitle)
            }
            .buttonStyle(PlainButtonStyle())

            if index != manager.searchResults.endIndex - 1 {
              Divider()
            }
          }
        }
      }
    }
  }
}
