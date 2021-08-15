//
//  MainViewController.swift
//  Navigation
//
//  Created by Samuel Shi on 8/8/21.
//

import Combine
import MapKit
import SwiftUI

struct MapItemView: View {
  @ObservedObject var mainManager: MainManager
  
  var body: some View {
    VStack {
      if let mapItem = mainManager.selectedMapItem {
        Button {
          mainManager.selectedLocation = Location(mapItem: mapItem)
        } label: {
          Text(mapItem.name ?? "")
        }
      }
      
      Spacer()
    }
    .padding()
  }
}

class MainViewController: DraggableModalViewController {
  var mainManager = MainManager.shared
  var searchManager = SearchManager()
  
  lazy var searchViewController: UIHostingController<SearchView> = {
    let searchView = SearchView(searchManager: searchManager)
    let hostingController = UIHostingController(rootView: searchView)
    hostingController.view?.backgroundColor = .clear
    hostingController.view?.translatesAutoresizingMaskIntoConstraints = false
    return hostingController
  }()
  
  lazy var mapItemViewController: UIHostingController<MapItemView> = {
    let mapItemView = MapItemView(mainManager: mainManager)
    let hostingController = UIHostingController(rootView: mapItemView)
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
    containerView.backgroundColor = .background
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 25),
      scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
    ])
    
    addSearchView()
    super.setUpViews()
  }
  
  func addSearchView() {
    scrollView.addSubview(searchViewController.view)
    NSLayoutConstraint.activate([
      searchViewController.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
      searchViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      searchViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      searchViewController.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
    ])
  }
  
  func addMapItemView() {
    scrollView.addSubview(mapItemViewController.view)
    NSLayoutConstraint.activate([
      mapItemViewController.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
      mapItemViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      mapItemViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      mapItemViewController.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
    ])
  }
  
  override func didChangeModalHeight(newHeight: CGFloat, fromKeyboard: Bool) {
    super.didChangeModalHeight(newHeight: newHeight, fromKeyboard: fromKeyboard)

    scrollView.isScrollEnabled = newHeight == maximumContainerHeight
    if !fromKeyboard { mainManager.dismissKeyboard() }
  }
  
  func setUpObservers() {
    NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
      .sink { [weak self] _ in
        guard let self = self else { return }
        self.animateContainerHeight(height: self.maximumContainerHeight, fromKeyboard: true)
      }
      .store(in: &cancellables)
    
    searchManager.$mapItems
      .receive(on: DispatchQueue.main)
      .map { $0.map { SSAnnotation(mapItem: $0) } }
      .sink { annotations in
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotations(annotations)
      }
      .store(in: &cancellables)
    
    searchManager.$userRegion
      .receive(on: DispatchQueue.main)
      .sink { [weak self] region in
        guard let region = region else { return }
        self?.mapView.region = region
      }
      .store(in: &cancellables)
    
    mainManager.$selectedMapItem
      .receive(on: DispatchQueue.main)
      .sink { mapItem in
        guard let mapItem = mapItem else { return }
        self.searchViewController.view.removeFromSuperview()
        self.addMapItemView()
        
        let latitude = mapItem.placemark.coordinate.latitude - 0.0125
        let longitude = mapItem.placemark.coordinate.longitude
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        self.mapView.region = MKCoordinateRegion(center: coordinate, span: span)
        
        if let annotation = self.mapView.annotations.first(where: {
          let annotation = $0 as? SSAnnotation
          return annotation?.mapItem.url == mapItem.url
        }) {
          self.mapView.selectAnnotation(annotation, animated: true)
        }
        
        self.animateContainerHeight(height: self.defaultHeight, fromKeyboard: false)
      }
      .store(in: &cancellables)
  }
}

extension MainViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let annotation = annotation as? SSAnnotation else { return nil }
    let identifier = "SearchMapAnnotation"
    
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
    
    if annotationView != nil {
      annotationView?.annotation = annotation
    } else {
      let image = UIImage(named: annotation.mapItem.pointOfInterestCategory.toIcon())!
      annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      annotationView?.image = image
      annotationView?.frame.size = CGSize(width: 40, height: 40)
    }
    
    return annotationView
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    guard let annotation = view.annotation as? SSAnnotation else { return }
    mainManager.selectedMapItem = annotation.mapItem
    
    view.frame.size = CGSize(width: 60, height: 60)
  }
  
  func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
    mapItemViewController.view.removeFromSuperview()
    addSearchView()
    
    view.frame.size = CGSize(width: 40, height: 40)
    animateContainerHeight(height: defaultHeight, fromKeyboard: false)
  }
}

extension MainViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y < 0 {
      animateContainerHeight(height: defaultHeight, fromKeyboard: false)
      scrollView.isScrollEnabled = false
    }
    mainManager.dismissKeyboard()
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    mainManager.isScrolling = true
    mainManager.isScrolling = false
  }
}
