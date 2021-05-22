//
//  LocationManager.swift
//  Navigation
//
//  Created by Samuel Shi on 5/20/21.
//

import Foundation
import CoreLocation

//protocol LocationManagerDelegate: AnyObject {
//  func locationsDidChange(location: Location)
//}

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
  let locationManager = CLLocationManager()

  let minDistance: Double = 1000
  var oldLocation: CLLocation?

  @Published var distanceToDestination: Double = 0
  @Published var angleToDestination   : Double = 0
  @Published var heading: Double = 0
  
  var destination : CLLocation = .init(latitude: 37.7749, longitude: -122.4194)
  var userLocation: CLLocation = .init()
  
  override init() {
    super.init()

    self.locationManager.delegate = self
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation

    self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.startUpdatingLocation()
    
    self.locationManager.startUpdatingHeading()
  }

  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]
  ) {
    guard locationManager.authorizationStatus != .denied else { return }
    guard let location = locations.last else { return }
    
    userLocation = location
    calculateAngle()
    
    let distance = userLocation.distance(from: destination)
    distanceToDestination = Measurement(value: distance, unit: UnitLength.meters).converted(to: .miles).value
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    heading = newHeading.magneticHeading
    calculateAngle()
  }

  func calculateAngle() {
    angleToDestination = heading - userLocation.angleTo(destination: destination)
  }
  
  func requestPreciseLocation() {
    if locationManager.accuracyAuthorization == .reducedAccuracy {
      locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "ForDirections") { error in
        print(error.debugDescription)
      }
    }
  }
}
