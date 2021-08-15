//
//  MainManager.swift
//  Navigation
//
//  Created by Samuel Shi on 8/8/21.
//

import Foundation
import MapKit
import SwiftUI

class MainManager: ObservableObject {
  static let shared = MainManager()

  @Published var selectedLocation: Location?
  @Published var selectedMapItem: MKMapItem?
  @Published var isScrolling = false

  func dismissKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
