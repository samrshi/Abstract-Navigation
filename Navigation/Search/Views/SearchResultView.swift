//
//  SearchResultView.swift
//  Navigation
//
//  Created by Samuel Shi on 5/29/21.
//

import SwiftUI
import MapKit

struct SearchResultView: View {
  let imageName: String
  let title: String
  let subtitle: String
  
  var body: some View {
    HStack {
      Image(imageName)
        .resizable()
        .scaledToFit()
        .frame(width: 40, height: 40)
      
      VStack(alignment: .leading) {
        Text(title)
          .bold()
        
        Text(subtitle)
      }
      .padding(.vertical, 5)
      .font(.subheadline)
    }
    .animation(.none)
  }
}
