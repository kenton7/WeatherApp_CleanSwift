//
//  CurrentWeatherModel.swift
//  WeatherApp_CleanSwift
//
//  Created by Илья Кузнецов on 18.01.2024.
//

import Foundation

enum Language: String {
    case ru = "ru"
    case en = "en"
}

protocol CurrentWeatherProtocol {
    var coord: Coord? { get }
    var weather: [Weather]? { get }
    var main: Main? { get }
    var wind: Wind? { get }
    var dt: Int? { get }
    var name: String? { get }
}

struct Coord: Codable {
    let lon, lat: Double?
}

struct CurrentWeatherModel: Codable, CurrentWeatherProtocol {
    let coord: Coord?
    var weather: [Weather]?
    let main: Main?
    let wind: Wind?
    var dt: Int?
    let name: String?
    
    enum CodingKeys: CodingKey {
        case coord
        case weather
        case main
        case wind
        case dt
        case name
    }
}

struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity, seaLevel, grndLevel: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

struct Weather: Codable {
    let id: Int?
    let main, description, icon: String?
}

struct Wind: Codable {
    let speed: Double?
}
