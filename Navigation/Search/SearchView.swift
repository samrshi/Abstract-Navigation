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
    .fullscreenBackground(Color.myBackground)
    .padding()
  }
  
  func geocode(_ completionResult: MKLocalSearchCompletion) {
    searchManager.geocode(completionResult: completionResult) { result in
      mainManager.selectedLocation = result
    }
  }
}

extension Color {
  static let myBackground = Color(UIColor.myBackground)
}

extension UIColor {
  static let myBackground = UIColor(red: 19 / 255, green: 27 / 255, blue: 36 / 255, alpha: 1)
}

struct SearchView_Previews: PreviewProvider {
  static var previews: some View {
    SearchView(searchManager: SearchManager())
      .preferredColorScheme(.dark)
  }
}

extension View {
  func fullscreenBackground<Content: View>(_ background: Content) -> some View {
    return ZStack {
      background.ignoresSafeArea()

      self
    }
  }

  func myCard() -> some View {
    self
      .padding()
      .background(Color(#colorLiteral(red: 0.108425118, green: 0.1537648737, blue: 0.2002459466, alpha: 1)))
      .cornerRadius(10)
  }
}

extension Optional where Wrapped == MKPointOfInterestCategory {
  func toIcon() -> String {
    guard let self = self else { return "arrow.up" }

    switch self {
    case .airport:
      return "arrow.up"
    case .aquarium:
      return "arrow.up"
    case .atm:
      return "arrow.up"
    case .bakery:
      return "arrow.up"
    case .bank:
      return "arrow.up"
    case .beach:
      return "arrow.up"
    case .brewery:
      return "arrow.up"
    case .cafe:
      return "arrow.up"
    case .campground:
      return "arrow.up"
    case .carRental:
      return "arrow.up"
    case .evCharger:
      return "arrow.up"
    case .fireStation:
      return "arrow.up"
    case .fitnessCenter:
      return "arrow.up"
    case .foodMarket:
      return "arrow.up"
    case .gasStation:
      return "arrow.up"
    case .hospital:
      return "arrow.up"
    case .hotel:
      return "arrow.up"
    case .laundry:
      return "arrow.up"
    case .library:
      return "arrow.up"
    case .marina:
      return "arrow.up"
    case .movieTheater:
      return "arrow.up"
    case .museum:
      return "arrow.up"
    case .nationalPark:
      return "arrow.up"
    case .nightlife:
      return "arrow.up"
    case .park:
      return "arrow.up"
    case .parking:
      return "arrow.up"
    case .pharmacy:
      return "arrow.up"
    case .police:
      return "arrow.up"
    case .postOffice:
      return "arrow.up"
    case .publicTransport:
      return "arrow.up"
    case .restaurant:
      return "arrow.up"
    case .restroom:
      return "arrow.up"
    case .school:
      return "arrow.up"
    case .stadium:
      return "arrow.up"
    case .store:
      return "arrow.up"
    case .theater:
      return "arrow.up"
    case .university:
      return "arrow.up"
    case .winery:
      return "arrow.up"
    case .zoo:
      return "arrow.up"
    default:
      return "arrow.up"
    }
  }
}
