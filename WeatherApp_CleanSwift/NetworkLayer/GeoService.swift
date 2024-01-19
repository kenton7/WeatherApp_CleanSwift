//
//  GeoService.swift
//  WeatherApp_CleanSwift
//
//  Created by Илья Кузнецов on 18.01.2024.
//

import Foundation

class GeoService {
    private let client: RestApiClient
    
    init(client: RestApiClient = .init() ) {
        self.client = client
    }
    
    func searchCity(_ city: String, completion: @escaping (Result<Geocoding, Error>) -> Void) {
        
        client.performRequest(WeatherEndpoints.geo(city: city)) { result in
            switch result {
            case .success(let geoData):
                do {
                    let city = try JSONDecoder().decode(Geocoding.self, from: geoData)
                    completion(.success(city))
                }
                catch let error {
                    print("error when parsing city JSON:: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("error searching city: \(error)")
                completion(.failure(error))
            }
        }
    }
}
