//
//  SearchStatusView.swift
//  Navigation
//
//  Created by Samuel Shi on 5/29/21.
//

import SwiftUI

struct SearchStatusView: View {
  @ObservedObject var manager: SearchManager

  var body: some View {
    Group {
      switch manager.status {
      case .noResults:
        Text("No Results")
      case .error(let description):
        Text("Error: \(description)")
      default:
        if manager.searchResults.isEmpty {
          HStack {
            Spacer()
            ProgressView()
            Spacer()
          }
        }
      }
    }.foregroundColor(.gray)
  }
}
