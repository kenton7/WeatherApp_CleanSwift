//
//  ForecastFactory.swift
//  WeatherApp_CleanSwift
//
//  Created by Илья Кузнецов on 18.01.2024.
//

import Foundation

final class ForecastFactory {
    
    class func makeForecastModelFromList(_ model: List) -> ForecastModel {
        return ForecastModel()
    }

    class func makeForecastModel(_ model: WeatherModelProtocol) -> ForecastModel {
        return ForecastModel(list: model.list, city: model.city)
    }
    
    class func makeForecastModelArray(_ model: WeatherModelProtocol) -> [ForecastModel] {
        return [ForecastModel(list: model.list, city: model.city)]
    }
}
