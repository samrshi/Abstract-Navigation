//
//  SelfSizingHostingController.swift
//  Navvy
//
//  Created by Samuel Shi on 10/9/21.
//

import SwiftUI

class SelfSizingHostingController<Content>: UIHostingController<Content> where Content: View {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.invalidateIntrinsicContentSize()
    }
}
