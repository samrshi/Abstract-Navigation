//
//  NavvySection.swift
//  Navvy
//
//  Created by Samuel Shi on 8/21/21.
//

import SwiftUI

struct NavvySection<Header: View, Content: View>: View {
  let header: Header
  @ViewBuilder let content: () -> Content

  var body: some View {
    VStack(alignment: .leading, spacing: 1) {
      HStack {
        header
          .foregroundColor(.secondary)

        Spacer()
      }

      HStack {
        content()
        
        Spacer()
      }
      .padding()
      .background(Color(.card))
      .cornerRadius(10)
    }
  }
}

struct NavvySection_Previews: PreviewProvider {
  static var previews: some View {
    NavvySection(header: Text("address").font(.caption)) {
      Text("Yo")
    }
    .preferredColorScheme(.dark)
    .padding()
    .fullscreenBackground(Color(.background))
  }
}
