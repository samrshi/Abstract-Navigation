//
//  SearchScreenNew.swift
//  Navigation
//
//  Created by Samuel Shi on 6/13/21.
//

import MapKit
import SwiftUI

struct SearchView: View {
  @ObservedObject var searchManager: SearchManager

  var body: some View {
    VStack(alignment: .leading) {
      Label("Search", systemImage: "magnifyingglass")
        .font(.title3.bold())

      VStack(alignment: .leading) {
        SearchFieldView(manager: searchManager)
          .padding(.horizontal, 5)

        SearchResultsView(manager: searchManager)
      }
      .myCard()
      .padding(.bottom)

      Spacer()

      HStack {
        Spacer()
      }
    }
    .padding()
    .animation(.none)
  }
}

struct SearchView_Previews: PreviewProvider {
  static var previews: some View {
    SearchView(searchManager: SearchManager())
      .preferredColorScheme(.dark)
  }
}
