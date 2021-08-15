//
//  MainViewController.swift
//  Navigation
//
//  Created by Samuel Shi on 8/8/21.
//

import Combine
import MapKit
import SwiftUI

class MainViewController: DraggableModalViewController {
  var manager = MainManager.shared
  var searchManager = SearchManager()
  
  lazy var hostingController: UIHostingController<SearchView> = {
    let searchView = SearchView(searchManager: searchManager)
    let hostingController = UIHostingController(rootView: searchView)
    hostingController.view?.backgroundColor = .clear
    hostingController.view?.translatesAutoresizingMaskIntoConstraints = false
    return hostingController
  }()
  
  lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.isScrollEnabled = false
    scrollView.delegate = self
    return scrollView
  }()
    
  lazy var mapView: MKMapView = {
    let view = MKMapView(frame: .zero)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.delegate = self
    view.isUserInteractionEnabled = true
    view.showsUserLocation = true
    return view
  }()
  
  var cancellables: [AnyCancellable] = []
  var publisher = PassthroughSubject<MKPlacemark, Never>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpObservers()
  }
  
  override func setUpViews() {
    view.addAndPinSubview(view: mapView)
    containerView.addSubview(scrollView)
    scrollView.addSubview(hostingController.view)
    containerView.backgroundColor = .background
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 25),
      scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
      
      hostingController.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
      hostingController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      hostingController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      hostingController.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
    ])
    
    super.setUpViews()
  }
  
  override func didChangeModalHeight(newHeight: CGFloat, fromKeyboard: Bool) {
    super.didChangeModalHeight(newHeight: newHeight, fromKeyboard: fromKeyboard)

    scrollView.isScrollEnabled = newHeight == maximumContainerHeight
    if !fromKeyboard { manager.dismissKeyboard() }
  }
}

extension MainViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y < 0 {
      animateContainerHeight(height: defaultHeight, fromKeyboard: false)
      scrollView.isScrollEnabled = false
    }
    manager.dismissKeyboard()
  }
}

extension MainViewController {
  func setUpObservers() {
    NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
      .sink { [weak self] _ in
        guard let self = self else { return }
        self.animateContainerHeight(height: self.maximumContainerHeight, fromKeyboard: true)
      }
      .store(in: &cancellables)
    
    searchManager.$mapItems
      .receive(on: DispatchQueue.main)
      .sink { [weak self] mapItems in
        self?.mapView.removeAnnotations(self?.mapView.annotations ?? [])
        self?.mapView.addAnnotations(mapItems.map(\.placemark))
      }
      .store(in: &cancellables)
  }
}

extension MainViewController: MKMapViewDelegate {
  func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
    DispatchQueue.main.async { [weak self] in
      self?.searchManager.region = mapView.region
    }
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    print("")
  }
}
