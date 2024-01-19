//
//  ForecastPresenter.swift
//  WeatherApp_CleanSwift
//
//  Created by Илья Кузнецов on 19.01.2024.
//

import Foundation

protocol ForecastViewControllerPresentationLogic {
    func presentForecast(data: [ForecastModelNew])
    func presentCurrentWeather(data: CurrentWeatherModel)
}

class ForecastPresenter {
    weak var forecastViewController: ForecastViewControllerDisplayLogic?
}

extension ForecastPresenter: ForecastViewControllerPresentationLogic {
    
    func presentForecast(data: [ForecastModelNew]) {
        forecastViewController?.displayForecast(data: data)
    }
    
    func presentCurrentWeather(data: CurrentWeatherModel) {
        forecastViewController?.displayCurrentWeather(data: data)
    }
    
}
