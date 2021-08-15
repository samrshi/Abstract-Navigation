//
//  LocationService.swift
//  Weather
//
//  Created by Samuel Shi on 5/25/2021.
//

import Combine
import Foundation
import MapKit

class SearchManager: NSObject, ObservableObject {
  enum LocationStatus: Equatable {
    case idle
    case noResults
    case isSearching
    case error(String)
    case result
  }
  
  @Published var queryFragment: String = ""
  @Published var status: LocationStatus = .idle
  @Published var searchResults: [MKLocalSearchCompletion] = []
  @Published var mapItems: [MKMapItem] = []
  @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.913200, longitude: -79.055847),
                                             span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
  let locationManager = LocationManager()
  var userRegion = MKCoordinateRegion()
  
  var cancellables: [AnyCancellable] = []
  var queryCancellable: AnyCancellable?
  var mapItemCancellable: AnyCancellable?
  
  let searchCompleter = MKLocalSearchCompleter()
  var publisher = PassthroughSubject<String, LocalSearchError>()
  
  override init() {
    super.init()
    
    searchCompleter.region = region
    searchCompleter.delegate = self
    searchCompleter.resultTypes = [.address, .pointOfInterest]
    
    setUpObserver()
  }
  
  func setUpObserver() {
    queryCancellable = $queryFragment
      .receive(on: DispatchQueue.main)
      .debounce(for: .milliseconds(500), scheduler: RunLoop.main, options: nil)
      .sink { [weak self] fragment in
        guard let self = self else { return }
        
        self.status = .isSearching
        if !fragment.isEmpty {
          self.searchCompleter.queryFragment = fragment
        } else {
          self.status = .idle
          self.searchResults = []
        }
      }
    
    mapItemCancellable = publisher
      .flatMap { query in
        LocalSearchPublishers.publishPlacemarks(completions: self.searchResults, region: self.region)
      }
      .replaceError(with: [])
      .eraseToAnyPublisher()
      .assign(to: \.mapItems, on: self)
    
    locationManager.locationsPublisher
      .map(\.last)
      .compactMap { $0 }
      .map { MKCoordinateRegion(center: $0.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)) }
      .assign(to: \.userRegion, on: self)
      .store(in: &cancellables)
    
    $region
      .assign(to: \.region, on: searchCompleter)
      .store(in: &cancellables)
  }
    
  func getMapItems() {
    publisher.send(queryFragment)
  }
}

extension SearchManager: MKLocalSearchCompleterDelegate {
  func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
    searchResults = completer.results
    status = completer.results.isEmpty ? .noResults : .result
  }
  
  func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
    status = .error(error.localizedDescription)
  }
}
