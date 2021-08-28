//
//  SSAnnotation.swift
//  Navigation
//
//  Created by Samuel Shi on 8/15/21.
//

import Foundation
import MapKit

class SSAnnotation: NSObject, MKAnnotation {
  var mapItem: MKMapItem

  init(mapItem: MKMapItem) {
    self.mapItem = mapItem
  }

  var title: String? {
    mapItem.name
  }
  
  var coordinate: CLLocationCoordinate2D {
    mapItem.placemark.coordinate
  }
}
