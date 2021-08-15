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

