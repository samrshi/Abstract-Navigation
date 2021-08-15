//
//  LocalSearchPublishers.swift
//  Navigation
//
//  Created by Samuel Shi on 8/9/21.
//

import Combine
import Foundation
import MapKit

enum LocalSearchError: Error {
  case noMapItems
  case other
}

enum LocalSearchPublishers {
  private static func localSearch(request: MKLocalSearch.Request, completion: @escaping (Result<[MKMapItem], LocalSearchError>) -> Void) {
    let search = MKLocalSearch(request: request)
    
    search.start { response, error in
      if error != nil {
        completion(.failure(.other))
      }

      if let mapItems = response?.mapItems {
        completion(.success(mapItems))
      } else {
        completion(.failure(.noMapItems))
      }
    }
  }
  
  static func geocode(query: String, region: MKCoordinateRegion) -> AnyPublisher<[MKMapItem], LocalSearchError> {
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = query
    request.region = region
    
    return Future { promise in
      localSearch(request: request, completion: promise)
    }
    .eraseToAnyPublisher()
  }
  
  static func geocode(completionResult: MKLocalSearchCompletion, region: MKCoordinateRegion) -> AnyPublisher<[MKMapItem], LocalSearchError> {
    let request = MKLocalSearch.Request(completion: completionResult)
    request.region = region
    
    return Future { promise in
      localSearch(request: request, completion: promise)
    }
    .eraseToAnyPublisher()
  }

  static func publishPlacemarks(completions: [MKLocalSearchCompletion], region: MKCoordinateRegion) -> AnyPublisher<[MKMapItem], LocalSearchError> {
    return completions.publisher
      .flatMap { geocode(completionResult: $0, region: region) }
      .compactMap(\.first)
      .collect()
      .eraseToAnyPublisher()
  }
}
