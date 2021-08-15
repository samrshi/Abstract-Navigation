//
//  SearchScreenNew.swift
//  Navigation
//
//  Created by Samuel Shi on 6/13/21.
//

import MapKit
import SwiftUI

struct SearchView: View {
  @ObservedObject var mainManager = MainManager.shared
  @ObservedObject var searchManager: SearchManager
  
  var body: some View {
    VStack(alignment: .leading) {
      Label("Your Favorites", systemImage: "heart.fill")
        .font(.title3.bold())

      VStack(alignment: .leading) {
        ForEach([Location.summit(), Location.starbucks()]) { location in
          HStack {
            Text(location.name)
            Spacer()
          }
          .padding(.vertical, 5)
        }
      }
      .myCard()
      .padding(.bottom)

      Label("Search", systemImage: "magnifyingglass")
        .font(.title3.bold())

      VStack(alignment: .leading) {
        SearchFieldView(manager: searchManager)
          .padding(5)

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
  }
}

struct SearchView_Previews: PreviewProvider {
  static var previews: some View {
    SearchView(searchManager: SearchManager())
      .preferredColorScheme(.dark)
  }
}
