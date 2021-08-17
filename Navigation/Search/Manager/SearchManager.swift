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
  
  let locationManager = LocationManager.shared
  
  var cancellable: AnyCancellable?
  var cancellables: [AnyCancellable] = []
  var queryCancellable: AnyCancellable?
  var mapItemCancellable: AnyCancellable?
  
  override init() {
    super.init()
    setUpObservers()
  }
  
  func setUpObservers() {
    queryCancellable = $queryFragment
      .receive(on: DispatchQueue.main)
      .debounce(for: .seconds(1), scheduler: RunLoop.main, options: nil)
      .sink { fragment in
        guard fragment != "" else { return }
        self.fetchLocations(query: fragment)
      }
    
    locationManager.locationsPublisher
      .compactMap { $0.last }
      .map {
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: $0.coordinate.latitude - 0.03, longitude: $0.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
      }
      .sink { region in
        if self.userRegion == nil {
          self.userRegion = region
        }
      }
      .store(in: &cancellables)
  }
  
  func fetchLocations(query: String) {
    self.status = .isSearching
    self.mapItemCancellable = LocalSearchPublishers.geocode(query: query, region: self.region)
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
