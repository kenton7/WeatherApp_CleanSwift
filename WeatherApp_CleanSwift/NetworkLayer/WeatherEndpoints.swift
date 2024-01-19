//
//  WeatherEndpoints.swift
//  WeatherApp_CleanSwift
//
//  Created by Илья Кузнецов on 18.01.2024.
//

import Foundation

enum WeatherEndpoints: URLRequestConvertable {
    case currentWeather(latitude: Double, longitude: Double, units: String, lang: LanguageType)
    case forecast(latitude: Double, longitude: Double, units: String, lang: LanguageType)
    case geo(city: String)
    
    var path: String {
        switch self {
        case .currentWeather:
            return "/data/2.5/weather"
        case .forecast:
            return "/data/2.5/forecast"
        case .geo:
            return "/geo/1.0/direct"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var urlQuery: [String : String] {
        switch self {
        case .currentWeather(let latitude, let longitude, let units, _),
             .forecast(let latitude, let longitude, let units, _):
            return [
                "lat": "\(latitude)",
                "lon": "\(longitude)",
                "lang": "\(LanguageType.ru.rawValue)",
                "appid": "\(APIKey.apiKey)",
                "units": "\(units)"
            ]
        case .geo(let city):
            return ["q": "\(city)", "limit": "1", "appid": "\(APIKey.apiKey)"]
        }
    }
}
