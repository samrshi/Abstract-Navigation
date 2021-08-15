//
//  Locatin.swift
//  Navigation
//
//  Created by Samuel Shi on 5/25/21.
//

import Foundation
import MapKit

struct Location: Identifiable {
  var id = UUID()

  let name: String
  let latitude: Double
  let longitude: Double
  
  init(name: String, latitude: Double, longitude: Double) {
    self.name = name
    self.latitude = latitude
    self.longitude = longitude
  }
  
  init?(mapItem: MKMapItem?) {
    guard let mapItem = mapItem,
          let name = mapItem.name else {
      return nil
    }
    
    let coordinate = mapItem.placemark.coordinate
    self = Location(name: name, latitude: coordinate.latitude, longitude: coordinate.longitude)
  }

  static func summit() -> Location {
    Location(name: "Summit Coffee Co.", latitude: 35.9129114, longitude: -79.0579603)
  }
  
  static func starbucks() -> Location {
    Location(name: "Starbucks", latitude: 35.9129114, longitude: -79.0579603)
  }
}
