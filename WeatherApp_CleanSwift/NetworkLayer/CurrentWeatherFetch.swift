//
//  CurrentWeatherFetch.swift
//  WeatherApp_CleanSwift
//
//  Created by Илья Кузнецов on 18.01.2024.
//

import Foundation

enum LanguageType: String {
    case ru = "ru"
    case en = "en"
}

class CurrentWeatherFetch {
    
    private let client: RestApiClient
    
    init(client: RestApiClient = .init() ) {
        self.client = client
    }
    
    func getCurrentWeather(longitute: Double, latitude: Double, units: String, language: LanguageType, completion: @escaping (Result<CurrentWeatherModel, Error>) -> Void) {
                
        client.performRequest(WeatherEndpoints.currentWeather(latitude: latitude, longitude: longitute, units: units, lang: language)) { result in
            
            switch result {
            case .success(let data):
                let weather = try! JSONDecoder().decode(CurrentWeatherModel.self, from: data)
                completion(.success(weather))
            case .failure(let error):
                print("ERROR: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}
