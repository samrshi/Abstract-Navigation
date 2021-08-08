//
//  LocationManager.swift
//  Navigation
//
//  Created by Samuel Shi on 5/20/21.
//

import CoreLocation
import Foundation

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
  let locationManager = CLLocationManager()

  let minDistance: Double = 1000
  var oldLocation: CLLocation?

  @Published var distanceToDestination: String = ""
  @Published var distanceUnit: String = "mi"

  @Published var angleToDestination: Double = 0
  @Published var heading: Double = 0

  var destination: CLLocation = .init(latitude: 37.7749, longitude: -122.4194)
  var userLocation: CLLocation = .init()

  init(location: Location) {
    super.init()

    destination = CLLocation(
      latitude: location.latitude,
      longitude: location.longitude)

    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation

    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()

    locationManager.startUpdatingHeading()
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard locationManager.authorizationStatus != .denied else { return }
    guard let location = locations.last else { return }

    userLocation = location
    calculateAngle()

    var distance = userLocation.distance(from: destination)

    var unit: UnitLength
    if distance <= 500 {
      unit = .feet
      distanceUnit = "feet"
    } else {
      unit = .miles
      distanceUnit = "miles"
    }

    distance = Measurement(value: distance, unit: UnitLength.meters).converted(to: unit).value

    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = distance > 1 ? 0 : 1

    distanceToDestination = formatter.string(from: NSNumber(floatLiteral: distance))!
  }

  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    heading = newHeading.magneticHeading
    calculateAngle()
  }

  func calculateAngle() {
    let angle = heading - userLocation.angleTo(destination: destination)
    angleToDestination = angle
  }

  func requestPreciseLocation() {
    if locationManager.accuracyAuthorization == .reducedAccuracy {
      locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "ForDirections") { error in
        print(error.debugDescription)
      }
    }
  }
}
