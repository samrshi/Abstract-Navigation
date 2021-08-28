//
//  LocationService.swift
//  Weather
//
//  Created by Samuel Shi on 5/25/2021.
//

import Combine
import Foundation
import MapKit

extension MKMapItem: Identifiable {
  public var id: UUID {
    UUID()
  }
}

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
  @Published var mapItems: [MKMapItem] = []

  @Published var userRegion: MKCoordinateRegion?
  @Published var region = MKCoordinateRegion()
  
  @Published var searchResults: [MKLocalSearchCompletion] = []
  @Published var selectedCompletion: MKLocalSearchCompletion?
  @Published var selectedMapItem: MKMapItem?
  
  let searchCompleter = MKLocalSearchCompleter()
  let locationManager: LocationManager
  
  var cancellable: AnyCancellable?
  var cancellables: [AnyCancellable] = []
  var queryCancellable: AnyCancellable?
  var mapItemCancellable: AnyCancellable?
  
  override init() {
    if let manager = LocationManager.shared {
      self.locationManager = manager
    } else {
      let manager = LocationManager()
      self.locationManager = manager
      LocationManager.shared = manager
    }
    super.init()
    searchCompleter.delegate = self
    searchCompleter.resultTypes = [.address, .pointOfInterest]
    setUpObservers()
  }
  
  func setUpObservers() {
    queryCancellable = $queryFragment
      .receive(on: DispatchQueue.main)
      .debounce(for: .milliseconds(250), scheduler: RunLoop.main, options: nil)
      .sink { fragment in
        self.status = .isSearching
        if !fragment.isEmpty {
          self.searchCompleter.queryFragment = fragment
        } else {
          self.status = .idle
          self.searchResults = []
        }
      }
    
    $selectedCompletion
      .compactMap { $0 }
      .sink { _ in
      } receiveValue: { completion in
        self.fetchMapItem(completion: completion)
      }
      .store(in: &cancellables)
    
    locationManager.locationsPublisher
      .compactMap { $0.last }
      .map {
        MKCoordinateRegion.customRegion(for: $0.coordinate, radius: 0.1)
      }
      .sink { region in
        if self.userRegion == nil {
          self.userRegion = region
        }
      }
      .store(in: &cancellables)
  }
  
  func fetchMapItem(completion: MKLocalSearchCompletion) {
    LocalSearchPublishers.geocode(completionResult: completion, region: nil)
      .map(\.first)
      .receive(on: DispatchQueue.main)
      .sink { completion in
        if case .failure(let error) = completion {
          self.status = .error(error.localizedDescription)
        }
      } receiveValue: { mapItem in
        self.selectedMapItem = mapItem
      }
      .store(in: &cancellables)
  }
  
  func fetchLocations() {
    status = .isSearching
    mapItemCancellable = LocalSearchPublishers.publishPlacemarks(completions: searchResults, region: region)
      .receive(on: DispatchQueue.main)
      .sink { completion in
        if case .failure(let error) = completion {
          self.status = .error(error.localizedDescription)
        }
      } receiveValue: { mapItems in
        self.mapItems = mapItems
        self.status = mapItems.isEmpty ? .noResults : .idle
        self.mapItemCancellable = nil
      }
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
