//
//  LocationManager+Angle.swift
//  Navigation
//
//  Created by Samuel Shi on 5/21/21.
//

import Foundation
import CoreLocation

extension CLLocation {
  func angleTo(destination: CLLocation) -> Double {
    let dX = destination.coordinate.latitude  - coordinate.latitude
    let dY = destination.coordinate.longitude - coordinate.longitude
    
    let vector = [dX, dY]
    let north  = [1.0, 0.0]
    
    let magnitude = mag(vector: vector)
    let cosTheta = dotProduct(u: vector, v: north) / magnitude
    
    var sign = 1.0
    if dY != 0 { sign = dY / abs(dY) }
    
    return sign * acos(cosTheta) * 180 / .pi
  }
  
  private func mag(vector: [Double]) -> Double {
    var sum: Double = 0
    for element in vector {
      sum += element * element
    }
    return sum.squareRoot()
  }
  
  private func dotProduct(u: [Double], v: [Double]) -> Double {
    guard u.count == v.count else { fatalError() }
    var result: Double = 0
    for (index, element) in u.enumerated() {
      result += element * v[index]
    }
    return result
  }
}
