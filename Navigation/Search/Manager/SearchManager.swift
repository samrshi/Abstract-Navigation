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
  @Published private(set) var status: LocationStatus = .idle
  @Published private(set) var searchResults: [MKLocalSearchCompletion] = []
  
  private var queryCancellable: AnyCancellable?
  private let searchCompleter: MKLocalSearchCompleter!
  
  init(searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()) {
    self.searchCompleter = searchCompleter
    
    super.init()
    
    self.searchCompleter.delegate = self
    self.searchCompleter.resultTypes = [.address, .pointOfInterest]
    
    self.queryCancellable = $queryFragment
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
  
  func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
    self.status = .error(error.localizedDescription)
  }
    
  func geocode(completionResult: MKLocalSearchCompletion, completion: @escaping (Location) -> Void) {
    let request = MKLocalSearch.Request(completion: completionResult)
    let search = MKLocalSearch(request: request)
    
    search.start { response, error in
      if let error = error {
        fatalError("MKLocalSearch error: \(error.localizedDescription)")
      }
      
      guard let mapItem = response?.mapItems.first, let name = mapItem.name else {
        fatalError("No map items")
      }
      
      let result = Location(
        name: name,
        latitude: mapItem.placemark.coordinate.latitude,
        longitude: mapItem.placemark.coordinate.longitude)
      
      completion(result)
    }
  }
}
