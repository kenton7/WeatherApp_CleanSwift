//
//  ForecastModel.swift
//  WeatherApp_CleanSwift
//
//  Created by Илья Кузнецов on 18.01.2024.
//

import Foundation

protocol WeatherModelProtocol {
    var list: [List]? { get }
    var city: City? { get }
}

struct ForecastModelNew {
    var maxTemp: Int
    var minTemp: Int
    var weatherID: Int
    //var weatherDescription: String
    var weatherDescriptionFromServer: String = ""
    /// Вычисляемое свойство для регулировки описания погоды, если в описании погоды 2 и более слова, так как с сервера приходит все с маленькой буквы
    var weatherDescriptionComputed: String {
        get {
            var finalStr = ""
            let separated = weatherDescriptionFromServer.components(separatedBy: " ")
            let descriptionCapitalaized = "\(separated[0].capitalized)\n\(separated.last ?? "")"
            if separated.count == 2 {
                finalStr = descriptionCapitalaized
            } else if separated.count == 3 {
                finalStr = "\(separated[0].capitalized) \(separated[1])\n\(separated.last ?? "")"
            } else {
                finalStr = weatherDescriptionFromServer.prefix(1).uppercased() + (weatherDescriptionFromServer.lowercased().dropFirst())
            }
            return finalStr
        }
    }
    var date: String
    var dayOrNight: String
}

struct ForecastModel: Codable, WeatherModelProtocol {
    var list: [List]?
    var city: City?
}

struct City: Codable {
    let name: String?
    let coord: Coord?
}

struct List: Codable {
    let dt: Int?
    let main: MainClass?
    let weather: [Weather]?
    let wind: Wind?
    let visibility: Int?
    let pop: Double?
    let dateString: String?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, wind, visibility, pop, sys
        case dateString = "dt_txt"
        case rain
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dt = try container.decodeIfPresent(Int.self, forKey: .dt)
        self.main = try container.decodeIfPresent(MainClass.self, forKey: .main)
        self.weather = try container.decodeIfPresent([Weather].self, forKey: .weather)
        self.wind = try container.decodeIfPresent(Wind.self, forKey: .wind)
        self.visibility = try container.decodeIfPresent(Int.self, forKey: .visibility)
        self.pop = try container.decodeIfPresent(Double.self, forKey: .pop)
        self.dateString = try container.decodeIfPresent(String.self, forKey: .dateString)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.dt, forKey: .dt)
        try container.encodeIfPresent(self.main, forKey: .main)
        try container.encodeIfPresent(self.weather, forKey: .weather)
        try container.encodeIfPresent(self.wind, forKey: .wind)
        try container.encodeIfPresent(self.visibility, forKey: .visibility)
        try container.encodeIfPresent(self.pop, forKey: .pop)
        try container.encodeIfPresent(self.dateString, forKey: .dateString)
    }
}

struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, seaLevel, grndLevel, humidity: Int?
    let tempKf: Double?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}
