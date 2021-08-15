//
//  Category+Image.swift
//  Navigation
//
//  Created by Samuel Shi on 8/8/21.
//

import Foundation
import MapKit

extension Optional where Wrapped == MKPointOfInterestCategory {
  func toIcon() -> String {
    guard let self = self else { return "default" }

    switch self {
    case .airport:
      return "airport"
    case .aquarium:
      return "aquarium"
    case .atm:
      return "atm"
    case .bakery:
      return "bakery"
    case .bank:
      return "bank"
    case .beach:
      return "beach"
    case .brewery:
      return "brewery"
    case .cafe:
      return "cafe"
    case .campground:
      return "campground"
    case .carRental:
      return "car-rental"
    case .evCharger:
      return "ev-charger"
    case .fireStation:
      return "fire-station"
    case .fitnessCenter:
      return "fitness-center"
    case .foodMarket:
      return "food-market"
    case .gasStation:
      return "gas-station"
    case .hospital:
      return "hospital"
    case .hotel:
      return "hotel"
    case .laundry:
      return "laundry"
    case .library:
      return "library"
    case .marina:
      return "marina"
    case .movieTheater:
      return "movie-theater"
    case .museum:
      return "museum"
    case .nationalPark:
      return "national-park"
    case .nightlife:
      return "nightlife"
    case .park:
      return "park"
    case .parking:
      return "parking"
    case .pharmacy:
      return "pharmacy"
    case .police:
      return "police"
    case .postOffice:
      return "post-office"
    case .publicTransport:
      return "public-transport"
    case .restaurant:
      return "restaurant"
    case .restroom:
      return "restroom"
    case .school:
      return "school"
    case .stadium:
      return "stadium"
    case .store:
      return "store"
    case .theater:
      return "theater"
    case .university:
      return "university"
    case .winery:
      return "winery"
    case .zoo:
      return "zoo"
    default:
      return "default"
    }
  }
}

