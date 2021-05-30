//
//  SearchResultsView.swift
//  Navigation
//
//  Created by Samuel Shi on 5/29/21.
//

import SwiftUI
import MapKit

struct SearchResultsView: View {
  @ObservedObject var manager: SearchManager
  @Binding var location: Location?
  
  var body: some View {
    Group {
      if !manager.queryFragment.isEmpty {
        List {
          SearchStatusView(manager: manager)
          
          ForEach(manager.searchResults, id: \.self) { result in
            Button(action: { geocode(result) }) {
              SearchResultView(result: result)
            }
            .buttonStyle(PlainButtonStyle())
          }
        }
      }
    }
  }
  
  func geocode(_ completionResult: MKLocalSearchCompletion) {
    manager.geocode(completionResult: completionResult) { result in
      location = result
    }
  }
}
