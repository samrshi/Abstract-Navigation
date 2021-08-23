//
//  String+RawPhoneNumber.swift
//  Navvy
//
//  Created by Samuel Shi on 8/22/21.
//

import Foundation

extension String {
  func rawPhoneNumber() -> String {
    return self.components(separatedBy: .alphanumerics.inverted).joined()
  }
}
