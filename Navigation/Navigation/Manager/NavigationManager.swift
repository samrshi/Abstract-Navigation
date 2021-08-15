//
//  LocationManager.swift
//  Navigation
//
//  Created by Samuel Shi on 5/20/21.
//

import Combine
import CoreLocation
import Foundation

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

class NavigationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
  let locationManager = LocationManager.shared

  let minDistance: Double = 1000
  var oldLocation: CLLocation?

  @Published var distanceToDestination: String = ""
  @Published var distanceUnit: String = "mi"

  @Published var angleToDestination: Double = 0
  @Published var heading: Double = 0

  var destination: CLLocation = .init(latitude: 37.7749, longitude: -122.4194)
  var userLocation: CLLocation = .init()
  var cancellables: [AnyCancellable] = []
  
  init(location: Location) {
    super.init()

    destination = CLLocation(
      latitude: location.latitude,
      longitude: location.longitude)
    
    locationManager.locationsPublisher
      .sink { [weak self] locations in
        self?.didUpdateLocations(locations: locations)
      }
      .store(in: &cancellables)
    
    locationManager.headingPublisher
      .sink { [weak self] heading in
        self?.didUpdateHeading(newHeading: heading)
      }
      .store(in: &cancellables)
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
