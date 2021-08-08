//
//  MainViewController+View.swift
//  Navigation
//
//  Created by Samuel Shi on 8/8/21.
//

import SwiftUI

extension MainViewController {
  struct View: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MainViewController {
      MainViewController()
    }
    
    func updateUIViewController(_ uiViewController: MainViewController, context: Context) {}
  }
}

