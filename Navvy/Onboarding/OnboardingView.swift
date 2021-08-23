//
//  OnboardingView.swift
//  Navvy
//
//  Created by Samuel Shi on 8/17/21.
//

import SwiftUI

struct OnboardingView: View {
  let image: String
  let title: String
  let description: String
  let buttonText: String
  let action: () -> Void

  var body: some View {
    VStack {
      Image(image)
        .resizable()
        .scaledToFit()
        .frame(height: UIScreen.main.bounds.height * 6 / 11)
      
      Text(title)
        .font(.system(size: 27))
        .bold()
        .padding(.bottom)

      Text(description)
        .multilineTextAlignment(.center)
        .font(.system(size: 15))
      
      Spacer()

      Button {
        action()
      } label: {
        Text(buttonText)
          .font(.title3)
          .bold()
          .foregroundColor(.white)
          .padding()
          .frame(width: UIScreen.main.bounds.width * 7 / 8)
          .background(Color.blue)
          .cornerRadius(16)
      }
    }
    .padding()
    .fullscreenBackground(Color(.background))
  }
}

struct OnboardingView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingView(image: "navvy-ill",
                   title: "Enable Location Permissions",
                   description: "Navvy uses your location to help you search\nfor nearby locations and to show how to\nget to your destination.",
                   buttonText: "Okay, I understand!",
                   action: {})  }
}
