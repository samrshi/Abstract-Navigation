//
//  SearchResultView.swift
//  Navigation
//
//  Created by Samuel Shi on 5/29/21.
//

import MapKit
import SwiftUI

struct SearchResultView: View {
  let title: String
  let subtitle: String

  var body: some View {
    VStack(alignment: .leading) {
      Text(title)
        .font(.headline)
        .padding(.bottom, 1)

      if subtitle != "" {
        Text(subtitle)
          .font(.caption)
      }
    }
  }
}
