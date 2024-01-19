//
//  CurrentWeatherFactory.swift
//  WeatherApp_CleanSwift
//
//  Created by Илья Кузнецов on 19.01.2024.
//

import Foundation
import RealmSwift

final class CurrentWeatherFactory {
    
    class func makeCurrentWeatherModel(_ model: CurrentWeatherProtocol) -> CurrentWeatherModel {
        return CurrentWeatherModel(coord: model.coord, weather: model.weather, main: model.main, wind: model.wind, dt: model.dt, name: model.name)
    }
    
    class func makeRealmModel(_ model: CurrentWeatherProtocol, cityName: String?) -> [RealmModel] {
        if let city = cityName,
           let weatherDescription = model.weather?.first?.description,
           let temp = model.main?.temp?.rounded(),
           let dayOrNight = model.weather?.first?.icon?.last,
           let id = model.weather?.first?.id,
           let latitude = model.coord?.lat,
           let longitude = model.coord?.lon {
            return [RealmModel(cityName: city, dayOrNight: String(dayOrNight), weatherDescription: weatherDescription, id: id, temp: temp, latitude: latitude, longitude: longitude)]
        }
        return [RealmModel]()
    }
    
    class func makeUpdatedRealmModel(_ model: Results<RealmModel>) -> [RealmModel] {
        
        for data in model {
            return [RealmModel(cityName: data.cityName, dayOrNight: data.dayOrNight, weatherDescription: data.weatherDescription, id: data.id, temp: data.temp, latitude: data.latitude, longitude: data.longitude)]
        }
        return [RealmModel]()
    }
}
