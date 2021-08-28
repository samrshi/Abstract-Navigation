//
//  LocalSearchPublishers.swift
//  Navigation
//
//  Created by Samuel Shi on 8/9/21.
//

import Combine
import Foundation
import MapKit

enum LocalSearchPublishers {
  static func localSearch(request: MKLocalSearch.Request, completion: @escaping (Result<[MKMapItem], Error>) -> Void) {
    let search = MKLocalSearch(request: request)
    
    search.start { response, error in
      if let error = error {
        completion(.failure(error))
      }

      if let mapItems = response?.mapItems {
        completion(.success(mapItems))
      } else {
        completion(.success([]))
      }
    }
  }
  
  static func geocode(query: String, region: MKCoordinateRegion) -> AnyPublisher<[MKMapItem], Error> {
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = query
    request.region = region
    
    return Future { promise in
      localSearch(request: request, completion: promise)
    }
    .eraseToAnyPublisher()
  }
  
  static func geocode(completionResult: MKLocalSearchCompletion, region: MKCoordinateRegion?) -> AnyPublisher<[MKMapItem], Error> {
    let request = MKLocalSearch.Request(completion: completionResult)
    if let region = region {
      request.region = region
    }
    
    return Future { promise in
      localSearch(request: request, completion: promise)
    }
    .eraseToAnyPublisher()
  }

  static func publishPlacemarks(completions: [MKLocalSearchCompletion], region: MKCoordinateRegion) -> AnyPublisher<[MKMapItem], Error> {
    return completions.publisher
      .flatMap { geocode(completionResult: $0, region: region) }
      .compactMap(\.first)
      .collect()
      .eraseToAnyPublisher()
  }
}
