//
//  LocationService.swift
//  Weather
//
//  Created by Samuel Shi on 5/25/2021.
//

import Foundation
import Combine
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
  @Published private(set) var status: LocationStatus = .idle
  @Published private(set) var searchResults: [MKLocalSearchCompletion] = []
  
  private var queryCancellable: AnyCancellable?
  private let searchCompleter: MKLocalSearchCompleter!
  
  init(searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()) {
    self.searchCompleter = searchCompleter
    
    super.init()
    
    self.searchCompleter.delegate = self
    self.searchCompleter.resultTypes = [.address, .pointOfInterest]
    
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
  }
}

extension SearchManager: MKLocalSearchCompleterDelegate {
  func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
    self.searchResults = completer.results
    self.status = completer.results.isEmpty ? .noResults : .result
  }
  
  func completer(_ completer: MKLocalSearchCompleter,
                 didFailWithError error: Error) {
    self.status = .error(error.localizedDescription)
  }
    
  func geocode(
    completionResult: MKLocalSearchCompletion,
    completion: @escaping (Location) -> Void
  ) {
    let geocoder = CLGeocoder()
    let key = completionResult.title + " " + completionResult.subtitle
    
    geocoder.geocodeAddressString(key) { placemarks, error in
      guard let placemark = placemarks?.first,
            let location  = placemark.location else { return }
      
      let result = Location(
        name: completionResult.title,
        latitude: location.coordinate.latitude,
        longitude: location.coordinate.longitude)
      
      completion(result)
    }
  }
}
