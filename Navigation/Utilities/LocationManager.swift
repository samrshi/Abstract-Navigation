//
//  LocationManager.swift
//  Navigation
//
//  Created by Samuel Shi on 8/17/21.
//

import Combine
import CoreLocation
import Foundation
import MapKit

class LocationManager: NSObject, CLLocationManagerDelegate {
  static let shared = LocationManager()

  let locationManager = CLLocationManager()

  let locationsPublisher = PassthroughSubject<[CLLocation], Never>()
  let headingPublisher = PassthroughSubject<CLHeading, Never>()

  override init() {
    super.init()

    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation

    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()

    locationManager.startUpdatingHeading()
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    locationsPublisher.send(locations)
  }

  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    headingPublisher.send(newHeading)
  }

  func requestPreciseLocation() {
    if locationManager.accuracyAuthorization == .reducedAccuracy {
      locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "ForDirections") { error in
        print(error.debugDescription)
      }
    }
  }
}
