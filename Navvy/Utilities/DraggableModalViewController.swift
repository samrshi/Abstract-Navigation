//
//  ModalVC.swift
//  Navigation
//
//  Created by Samuel Shi on 8/8/21.
//

import Combine
import MapKit
import SwiftUI

// To use, subclass DraggableModalViewController. Override setUpViews(), didChangeModalHeight(_:),
// and add/layout dragBarView
class DraggableModalViewController: UIViewController {
  lazy var containerView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 16
    view.clipsToBounds = true
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  lazy var dragBarView: UIView = {
    let dragBarView = UIView(frame: .zero)
    dragBarView.backgroundColor = .secondaryLabel
    dragBarView.layer.masksToBounds = true
    dragBarView.layer.cornerRadius = 2.5
    dragBarView.translatesAutoresizingMaskIntoConstraints = false
    return dragBarView
  }()
  
  // Constants
  let defaultHeight: CGFloat = UIScreen.main.bounds.height / 2
  let dismissibleHeight: CGFloat = UIScreen.main.bounds.height / 2.5
  let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
  let minumumContainerHeight: CGFloat = UIScreen.main.bounds.height / 4
  var currentContainerHeight: CGFloat = UIScreen.main.bounds.height / 4
    
  // Dynamic container constraint
  var containerViewHeightConstraint: NSLayoutConstraint?
  var containerViewBottomConstraint: NSLayoutConstraint?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpViews()
    setupPanGesture()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    animatePresentContainer()
  }
  
  func setUpViews() {
    view.backgroundColor = .clear

    view.addSubview(containerView)
    containerView.addSubview(dragBarView)
    
    NSLayoutConstraint.activate([
      dragBarView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
      dragBarView.widthAnchor.constraint(equalToConstant: 40),
      dragBarView.heightAnchor.constraint(equalToConstant: 5),
      dragBarView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      
      containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
    
    containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: currentContainerHeight)
    containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: currentContainerHeight)
    containerViewHeightConstraint?.isActive = true
    containerViewBottomConstraint?.isActive = true
  }
  
  func setupPanGesture() {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
    panGesture.delaysTouchesBegan = false
    panGesture.delaysTouchesEnded = false
    containerView.addGestureRecognizer(panGesture)
  }
    
  // MARK: Pan gesture handler

  @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: view)
    let isDraggingDown = translation.y > 0
    let newHeight = currentContainerHeight - translation.y
    
    guard allowTransition(newHeight: newHeight) else { return }

    MainManager.shared.dismissKeyboard()
    
    switch gesture.state {
    case .changed:
      if newHeight < maximumContainerHeight {
        containerViewHeightConstraint?.constant = newHeight
        view.layoutIfNeeded()
      }
    case .ended:
//      if isDraggingDown && currentContainerHeight == defaultHeight {
//        animateContainerHeight(height: minumumContainerHeight, fromKeyboard: false)
//      } else if !isDraggingDown && currentContainerHeight == defaultHeight {
//        animateContainerHeight(height: maximumContainerHeight, fromKeyboard: false)
//      } else if isDraggingDown && currentContainerHeight == maximumContainerHeight {
//        animateContainerHeight(height: defaultHeight, fromKeyboard: false)
//      } else if !isDraggingDown && currentContainerHeight == minumumContainerHeight {
//        animateContainerHeight(height: defaultHeight, fromKeyboard: false)
//      }
      if newHeight < defaultHeight, isDraggingDown {
        animateContainerHeight(height: minumumContainerHeight, fromKeyboard: false)
      }
      else if newHeight < defaultHeight, !isDraggingDown {
        animateContainerHeight(height: defaultHeight, fromKeyboard: false)
      }
      else if newHeight > defaultHeight, isDraggingDown {
        animateContainerHeight(height: defaultHeight, fromKeyboard: false)
      }
      else if newHeight > defaultHeight, !isDraggingDown {
        animateContainerHeight(height: maximumContainerHeight, fromKeyboard: false)
      }
    default:
      break
    }
  }
    
  func animateContainerHeight(height: CGFloat, fromKeyboard: Bool) {
    view.layoutIfNeeded()
    
    UIView.animate(withDuration: 0.4) {
      self.containerViewHeightConstraint?.constant = height
      self.view.layoutIfNeeded()
    }
    currentContainerHeight = height
    didChangeModalHeight(newHeight: currentContainerHeight, fromKeyboard: fromKeyboard)
  }
    
  @objc func animatePresentContainer() {
    UIView.animate(withDuration: 0.3) {
      self.containerViewBottomConstraint?.constant = 0
      self.view.layoutIfNeeded()
    }
  }
  
  func didChangeModalHeight(newHeight: CGFloat, fromKeyboard: Bool) {}
  
  func allowTransition(newHeight: CGFloat) -> Bool {
    return true
  }
}
