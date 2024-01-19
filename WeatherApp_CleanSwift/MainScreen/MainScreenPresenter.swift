//
//  MainScreenPresenter.swift
//  WeatherApp_CleanSwift
//
//  Created by Илья Кузнецов on 18.01.2024.
//

import Foundation

//В Презентере логика показа 
protocol MainScreenPresentationLogic {
    func presentCurrentWeather(data: CurrentWeatherModel)
    func presentForecast(data: [List])
}

class MainScreenPresenter {
    weak var mainViewController: MainViewControllerDisplayLogic?
}

//MARK: - MainScreenPresentationLogic
extension MainScreenPresenter: MainScreenPresentationLogic {
    
    func presentCurrentWeather(data: CurrentWeatherModel) {
        mainViewController?.display(currentWeather: data)
    }
    
    func presentForecast(data: [List]) {
        mainViewController?.displayForecast(data: data)
    }
    
}
