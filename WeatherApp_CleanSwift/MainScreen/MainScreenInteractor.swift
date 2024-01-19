//
//  MainScreenInteractor.swift
//  WeatherApp_CleanSwift
//
//  Created by Илья Кузнецов on 18.01.2024.
//

import Foundation
import UIKit.UIImage

//В Interactor вся бизнес-логика
protocol MainScreenBusinessLogic {
    func fetchCurrentWeather(latitude: Double, longitude: Double)
    func fetchForecast(latitude: Double, longitude: Double)
    func animateBackground(state: String, view: UIView)
    func refreshButtonPressed()
}

class MainScreenInteractor {
    
    var presenter: MainScreenPresentationLogic?
    let currentWeatherNetworkService = CurrentWeatherFetch()
    let forecastSerive = ForecastFetch()
    var coordinates: Coordinates?
    var units: String?
    
}

//MARK: - MainScreenBusinessLogic
extension MainScreenInteractor: MainScreenBusinessLogic {
    
    func refreshButtonPressed() {
        let privateQueue = DispatchQueue.global(qos: .utility)
        privateQueue.async { [weak self] in
            guard let self else { return }
            if let coordinates = UserDefaults.standard.data(forKey: "coordinates") {
                let decodedCoordinates = try! JSONDecoder().decode(Coordinates.self, from: coordinates)
                self.fetchCurrentWeather(latitude: decodedCoordinates.latitude, longitude: decodedCoordinates.longitude)
                self.fetchForecast(latitude: decodedCoordinates.latitude, longitude: decodedCoordinates.longitude)
            }
        }
    }
    
    func animateBackground(state: String, view: UIView) {
        guard let nightImage = UIImage(named: "nightSky"), let dayImage = UIImage(named: "BackgroundImage") else { return }
        
        if state == "d" {
            view.animateBackground(image: dayImage, on: view)
        } else {
            view.animateBackground(image: nightImage, on: view)
        }
    }
    
    
    func fetchCurrentWeather(latitude: Double, longitude: Double) {
        currentWeatherNetworkService.getCurrentWeather(longitute: longitude,
                                                       latitude: latitude,
                                                       units: UserDefaults.standard.string(forKey: "units") ?? "metric",
                                                       language: LanguageType.ru) { [weak self] currentWeatherResult in
            guard let self else { return }
            switch currentWeatherResult {
            case .success(let weatherData):
                self.presenter?.presentCurrentWeather(data: weatherData)
            case .failure(let error):
                print("error when get currentWeather: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchForecast(latitude: Double, longitude: Double) {
        
        var forecastDataSource = [List]()
        
        forecastSerive.getForecast(longitude: longitude,
                                   latitude: latitude,
                                   units: UserDefaults.standard.string(forKey: "units") ?? "metric",
                                   language: .ru) { [weak self] forecastResult in
            guard let self else { return }
            switch forecastResult {
            case .success(let forecastData):
                let factoryModel = ForecastFactory.makeForecastModel(forecastData)
                if let first8Items = factoryModel.list?.prefix(8) {
                    let arr = Array(first8Items)
                    forecastDataSource.append(contentsOf: arr)
                }
                self.presenter?.presentForecast(data: forecastDataSource)
            case .failure(let error):
                print("error when get forecast: \(error.localizedDescription)")
            }
        }
    }
}

