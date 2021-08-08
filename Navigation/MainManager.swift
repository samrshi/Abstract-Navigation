//
//  MainManager.swift
//  Navigation
//
//  Created by Samuel Shi on 8/8/21.
//

import Foundation
import SwiftUI

class MainManager: ObservableObject {
  static let shared = MainManager()
  
  @Published var selectedLocation: Location?
  
  func dismissKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
