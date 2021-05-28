//
//  Locatin.swift
//  Navigation
//
//  Created by Samuel Shi on 5/25/21.
//

import Foundation

struct Location: Identifiable {
  let id = UUID()
  
  let name     : String
  let latitude : Double
  let longitude: Double
}
