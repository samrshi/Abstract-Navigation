//
//  MKCoordinateRegion+Extensions.swift
//  Navvy
//
//  Created by Samuel Shi on 8/22/21.
//

import Foundation
import MapKit

extension MKCoordinateRegion {
  static func customRegion(for coordinate: CLLocationCoordinate2D, radius: Double) -> MKCoordinateRegion {
    let center = CLLocationCoordinate2D(latitude: coordinate.latitude - radius * 0.3,
                                        longitude: coordinate.longitude)
    return MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: radius, longitudeDelta: radius))
  }
}
