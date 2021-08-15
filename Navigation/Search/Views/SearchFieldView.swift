//
//  SearchFieldView.swift
//  Navigation
//
//  Created by Samuel Shi on 5/29/21.
//

import SwiftUI

struct SearchFieldView: View {
  @ObservedObject var manager: SearchManager
  
  var body: some View {
    ZStack(alignment: .trailing) {
      TextField("Search for a location...", text: $manager.queryFragment)
        .frame(height: 40)
      
      if manager.status == .isSearching {
        Image(systemName: "clock")
          .foregroundColor(Color.gray)
      }
    }
  }
}
