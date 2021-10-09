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
  var mainManager = MainManager.shared
  var searchManager = SearchManager()
  
  // UIScrollView doesn't allow content to resize in current iOS 15 beta. Idk why it's broken
  // I'm just going to wait until more versions of the beta to come out so I don't waste too much time on it
  
  lazy var searchViewController: SelfSizingHostingController<AnyView> = {
    let searchView = AnyView(SearchView(searchManager: searchManager))
//    let searchView = AnyView(MyView())
    
    let hostingController = SelfSizingHostingController(rootView: searchView)
    hostingController.view?.backgroundColor = .clear
    hostingController.view?.translatesAutoresizingMaskIntoConstraints = false
    return hostingController
  }()
  
  lazy var mapItemViewController: UIHostingController<MapItemView> = {
    let mapItemView = MapItemView(searchManager: searchManager)
    let hostingController = UIHostingController(rootView: mapItemView)
    hostingController.view?.backgroundColor = .clear
    hostingController.view?.translatesAutoresizingMaskIntoConstraints = false
    hostingController.view?.isHidden = true
    return hostingController
  }()
  
  var navigationViewController: UIHostingController<NavigationScreen>?
  
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
    view.accessibilityElementsHidden = true
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
    containerView.backgroundColor = .background
    
    containerView.addSubview(scrollView)
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 25),
      scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
    ])
    
    containerView.addSubview(mapItemViewController.view)
    NSLayoutConstraint.activate([
      mapItemViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
      mapItemViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      mapItemViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      mapItemViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
    ])
    
    scrollView.addSubview(searchViewController.view)
    scrollView.contentSize = searchViewController.view.frame.size
    NSLayoutConstraint.activate([
      searchViewController.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
      searchViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      searchViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      searchViewController.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
    ])
    
    super.setUpViews()
  }
  
  func addSearchView() {
    searchViewController.view.isHidden = false
  }
  
  func removeSearchView() {
    searchViewController.view.isHidden = true
  }
  
  func addMapItemView() {
    mapItemViewController.view.isHidden = false
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
      let height: CGFloat = self.mapItemViewController.view.sizeThatFits(CGSize(width: self.containerView.frame.width, height: .greatestFiniteMagnitude)).height
      self.animateContainerHeight(height: height < self.maximumContainerHeight ? height : self.maximumContainerHeight, fromKeyboard: false)
    }
  }
  
  func removeMapItemView() {
    mapItemViewController.view.isHidden = true
    
    let newHeight = searchManager.searchResults.isEmpty ? minumumContainerHeight : defaultHeight
    animateContainerHeight(height: newHeight, fromKeyboard: false)
  }
  
  func setUpObservers() {
    NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
      .sink { [weak self] _ in
        guard let self = self else { return }
        self.animateContainerHeight(height: self.maximumContainerHeight, fromKeyboard: true)
      }
      .store(in: &cancellables)
    
    NotificationCenter.default.publisher(for: .keyboardHiddenByUser)
      .sink { _ in
        if !self.mapItemViewController.view.isHidden {
          self.addMapItemView()
        } else {
          self.animateContainerHeight(height: self.defaultHeight, fromKeyboard: true)
        }
      }
      .store(in: &cancellables)
    
    searchManager.$searchResults
      .receive(on: DispatchQueue.main)
      .sink { _ in
        self.mapView.removeAnnotations(self.mapView.annotations)
      }
      .store(in: &cancellables)
    
    searchManager.$mapItems
      .receive(on: DispatchQueue.main)
      .map { $0.map { SSAnnotation(mapItem: $0) } }
      .sink { annotations in
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotations(annotations)
        self.animateContainerHeight(height: self.minumumContainerHeight, fromKeyboard: false)
        
        let latitudes = annotations.map(\.mapItem.placemark.coordinate.latitude)
        let longitudes = annotations.map(\.mapItem.placemark.coordinate.longitude)
        
        if let minLatitude = latitudes.min(),
           let maxLatitude = latitudes.max(),
           let minLongitude = longitudes.min(),
           let maxLongitude = longitudes.max()
        {
          let deltaLatitude = maxLatitude - minLatitude
          let deltaLongitude = maxLongitude - minLongitude
          let center = CLLocationCoordinate2D(latitude: minLatitude + (deltaLatitude / 2), longitude: minLongitude + (deltaLongitude / 2))
          let span = MKCoordinateSpan(latitudeDelta: deltaLatitude, longitudeDelta: deltaLongitude)
          self.changeRegion(region: MKCoordinateRegion(center: center, span: span))
        }
      }
      .store(in: &cancellables)
    
    searchManager.$userRegion
      .compactMap { $0 }
      .receive(on: DispatchQueue.main)
      .sink { region in
        self.changeRegion(region: region)
      }
      .store(in: &cancellables)
    
    searchManager.$selectedMapItem
      .receive(on: DispatchQueue.main)
      .sink { mapItem in
        if let mapItem = mapItem {
          self.removeSearchView()
          self.view.layoutIfNeeded()
          self.addMapItemView()
          
          let annotation = SSAnnotation(mapItem: mapItem)
          self.mapView.addAnnotation(annotation)
          let region = MKCoordinateRegion.customRegion(for: mapItem.placemark.coordinate, radius: 0.01)
          self.changeRegion(region: region)
        } else {
          self.removeMapItemView()
          self.view.layoutIfNeeded()
          self.addSearchView()
          
          self.mapView.removeAnnotations(self.mapView.annotations)
        }
      }
      .store(in: &cancellables)
    
    mainManager.$selectedMapItem
      .receive(on: DispatchQueue.main)
      .sink { mapItem in
        if mapItem != nil {
          let vc = UIHostingController(rootView: NavigationScreen())
          self.navigationViewController = vc
          vc.modalPresentationStyle = .fullScreen
          self.present(vc, animated: true)
        } else {
          self.navigationViewController?.dismiss(animated: true)
          self.navigationViewController = nil
        }
      }
      .store(in: &cancellables)
  }
  
  override func didChangeModalHeight(newHeight: CGFloat, fromKeyboard: Bool) {
    super.didChangeModalHeight(newHeight: newHeight, fromKeyboard: fromKeyboard)

    scrollView.isScrollEnabled = newHeight == maximumContainerHeight
    if !fromKeyboard { mainManager.dismissKeyboard() }
  }
  
  override func allowTransition(newHeight: CGFloat) -> Bool {
    return mapItemViewController.view.isHidden
  }
}

extension MainViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let annotation = annotation as? SSAnnotation else { return nil }
    let identifier = annotation.mapItem.pointOfInterestCategory.toIcon()
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
    searchManager.selectedMapItem = annotation.mapItem
    
    view.frame.size = CGSize(width: 60, height: 60)
  }
  
  func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
    removeMapItemView()
    addSearchView()
    
    view.frame.size = CGSize(width: 40, height: 40)
    animateContainerHeight(height: defaultHeight, fromKeyboard: false)
  }
    
  func changeRegion(region: MKCoordinateRegion) {
    UIView.animate(withDuration: 0.5) {
      self.mapView.region = region
    }
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
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    mainManager.isScrolling = false
  }
}
