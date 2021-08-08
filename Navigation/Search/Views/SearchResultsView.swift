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
    manager.geocode(completionResult: completionResult) { result in
      mainManager.selectedLocation = result
    }
  }
}
