//
//  SearchView.swift
//  Weather
//
//  Created by Samuel Shi on 5/25/2021.
//

import SwiftUI
import MapKit
import CoreLocation

struct SearchScreen: View {
  @Environment(\.presentationMode) var presentationMode
  @StateObject var manager = SearchManager()
  @Binding var location: Location?
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Search...")) {
          SearchFieldView(manager: manager)
        }
        
        Section(header: Text("Results")) {
          SearchResultsView(manager: manager, location: $location)
        }
      }
      .navigationBarTitle("Navigation")
      .navigationBarTitleDisplayMode(.large)
    }
  }
}

struct SearchView_Previews: PreviewProvider {
  static var previews: some View {
    SearchScreen(location: .constant(nil))
      .preferredColorScheme(.dark)
  }
}
