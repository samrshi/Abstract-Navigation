//
//  SearchResultView.swift
//  Navigation
//
//  Created by Samuel Shi on 5/29/21.
//

import SwiftUI
import MapKit

struct SearchResultView: View {
  let result: MKLocalSearchCompletion
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(result.title)
        .bold()
      
      Text(result.subtitle)
    }
    .padding(.vertical, 5)
    .font(.subheadline)
  }
}
