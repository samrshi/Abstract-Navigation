//
//  SearchView.swift
//  Weather
//
//  Created by Samuel Shi on 5/25/2021.
//

import SwiftUI
import MapKit
import CoreLocation

struct SearchView: View {
  @Environment(\.presentationMode) var presentationMode
  @StateObject var manager = SearchManager()

  @Binding var location: Location?
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Location Search")) {
          searchField

          if !manager.queryFragment.isEmpty {
            searchResults
          }
        }
      }
      .navigationBarTitle("Navigation")
      .navigationBarTitleDisplayMode(.large)
    }
  }

  var doneButton: some View {
    Button("Done") {
      presentationMode.wrappedValue.dismiss()
    }
  }

  var searchField: some View {
    ZStack(alignment: .trailing) {
      TextField("Search", text: $manager.queryFragment)

      if manager.status == .isSearching {
        Image(systemName: "clock")
          .foregroundColor(Color.gray)
      }
    }
  }

  var searchResults: some View {
    List {
      resultsStatus

      ForEach(manager.searchResults, id: \.self) { completionResult in
        Button(action: {
          print(completionResult.title)
          manager.geocode(completionResult: completionResult) { result in
            location = result
          }
        }, label: {
          VStack(alignment: .leading) {
            Text(completionResult.title)
              .font(.subheadline)
              .bold()
            Text(completionResult.subtitle)
              .font(.subheadline)
          }
        })
        .buttonStyle(PlainButtonStyle())
      }
    }
  }

  var resultsStatus: some View {
    Group {
      switch manager.status {
      case .noResults:
        Text("No Results")
      case .error(let description):
        Text("Error: \(description)")
      default:
        EmptyView()
      }
    }
    .foregroundColor(Color.gray)
  }
}

struct SearchView_Previews: PreviewProvider {
  static var previews: some View {
    SearchView(location: .constant(nil))
  }
}
