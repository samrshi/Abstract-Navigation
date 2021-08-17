//
//  LocationManager.swift
//  Navigation
//
//  Created by Samuel Shi on 5/20/21.
//

import Combine
import CoreLocation
import Foundation
import MapKit

class NavigationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
  let locationManager = CLLocationManager()

  let minDistance: Double = 1000
  var oldLocation: CLLocation?

  @Published var distanceToDestination: String = ""
  @Published var distanceUnit: String = "mi"

  @Published var angleToDestination: Double = 0
  @Published var heading: Double = 0

  var destination: CLLocation = .init()
  var userLocation: CLLocation = .init()

  init(mapItem: MKMapItem) {
    super.init()

    guard let location = mapItem.placemark.location else { return }
    destination = location

    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation

    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()

    locationManager.startUpdatingHeading()
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    didUpdateLocations(locations: locations)
  }

  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    didUpdateHeading(newHeading: newHeading)
  }

  func requestPreciseLocation() {
    if locationManager.accuracyAuthorization == .reducedAccuracy {
      locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "ForDirections") { error in
        print(error.debugDescription)
      }
    }
  }

  func didUpdateLocations(locations: [CLLocation]) {
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
    
    if distanceToDestination == "1", distanceUnit == "miles" {
      distanceUnit = "mile"
    }
  }

  func didUpdateHeading(newHeading: CLHeading) {
    heading = newHeading.magneticHeading
    calculateAngle()
  }

  func calculateAngle() {
    let angle = heading - userLocation.angleTo(destination: destination)
    angleToDestination = angle
  }
}
