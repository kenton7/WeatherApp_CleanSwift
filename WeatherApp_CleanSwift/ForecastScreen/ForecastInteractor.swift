//
//  ForecastInteractor.swift
//  WeatherApp_CleanSwift
//
//  Created by Илья Кузнецов on 19.01.2024.
//

import Foundation

protocol ForecastScreenBusinessLogic {
    func fetchForecast(latitude: Double, longitude: Double)
    func fetchCurrentWeather(latitude: Double, longitude: Double)
}

class ForecastInteractor {
    var presenter: ForecastViewControllerPresentationLogic?
    let forecastService = ForecastFetch()
    let currentWeatherService = CurrentWeatherFetch()
    var forecastData = [ForecastModelNew]()
}

//MARK: - ForecastScreenBusinessLogic
extension ForecastInteractor: ForecastScreenBusinessLogic {
    
        func fetchCurrentWeather(latitude: Double, longitude: Double) {
            currentWeatherService.getCurrentWeather(longitute: longitude,
                                                           latitude: latitude,
                                                           units: UserDefaults.standard.string(forKey: "units") ?? MeasurementsTypes.mertic.rawValue,
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
        self.forecastService.getForecast(longitude: longitude,
                                         latitude: latitude,
                                         units: UserDefaults.standard.string(forKey: "units") ?? MeasurementsTypes.mertic.rawValue, language: .ru) { forecastResult in
            
            switch forecastResult {
            case .success(let forecast):
                let calendar = Calendar.current
                let df = DateFormatter()

                for _ in forecast.list! {
                    //Фильтруем дату для каждого дня в определенное время,
                    //которое зависит от текущего часа (Например, сейчас 15:00),
                    //значит прогноз на другие дни показывается тоже в 15:00
                    let filteredData = forecast.list?.filter { entry in
                        let date = Date(timeIntervalSince1970: Double(entry.dt ?? 0))
                        
                        if calendar.component(.hour, from: Date()) == 00 {
                            return calendar.component(.hour, from: date) == 00
                        } else if calendar.component(.hour, from: Date()) % 3 == 0 {
                            return calendar.component(.hour, from: date) == calendar.component(.hour, from: Date())
                        } else if calendar.component(.hour, from: Date()) % 3 == 1 {
                            var today = calendar.component(.hour, from: Date()) + 2
                            if today >= 24 {
                                today = 00
                            }
                            return calendar.component(.hour, from: date) == today
                        } else if calendar.component(.hour, from: Date()) % 3 == 2 {
                            var today = calendar.component(.hour, from: Date()) + 1
                            if today >= 24 {
                                today = 00
                            }
                            return calendar.component(.hour, from: date) == today
                        } else {
                            return calendar.component(.hour, from: date) == 15
                        }
                    }
                    
                    for data in filteredData! {
                        df.dateFormat = "EEEE" // день недели
                        df.locale = Locale(identifier: "ru_RU")
                        df.timeZone = .current
                        let date = Date(timeIntervalSince1970: Double(data.dt ?? 0))
                        let dateString = df.string(from: date)
                        self.forecastData.append(ForecastModelNew(maxTemp: Int(data.main?.tempMax?.rounded() ?? 0.0),
                                                                  minTemp: Int(data.main?.tempMin?.rounded() ?? 0.0),
                                                                  weatherID: data.weather?.first?.id ?? 0,
                                                                  weatherDescriptionFromServer: data.weather?.first?.description?.capitalizingFirstLetter() ?? "",
                                                                  date: dateString.capitalizingFirstLetter(),
                                                                  dayOrNight: String(data.weather?.first?.icon?.last ?? "d")))
                    }
                    self.presenter?.presentForecast(data: self.forecastData)
                    return
                }
            case .failure(let error):
                print("error getting forecast: \(error.localizedDescription)")
            }
        }
    }
}
