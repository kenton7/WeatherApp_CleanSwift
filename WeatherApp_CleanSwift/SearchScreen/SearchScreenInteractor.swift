//
//  SearchScreenInteractor.swift
//  WeatherApp_CleanSwift
//
//  Created by Илья Кузнецов on 19.01.2024.
//

import Foundation
import RealmSwift
import UIKit.UIContextualAction

protocol SearchScreenBusinessLogic {
    func search(city: String)
    func updateWeatherIn(city: String, indexPath: IndexPath)
    func locationButtonPressed(longitude: Double, latitude: Double)
    func deleteDataFromRealm(indexPath: IndexPath)
    func customDeleteButton(action: UIContextualAction) -> UISwipeActionsConfiguration
}

class SearchScreenInteractor {
    var presenter: SearchScreenPresentationLogic?
    let currentWeatherService = CurrentWeatherFetch()
    let geoService = GeoService()
    var coordinates: Coordinates?
    var units: String?
    var forecastRealm: Results<RealmModel>!
    private lazy var realm = try! Realm()
}

extension SearchScreenInteractor: SearchScreenBusinessLogic {
    
    func customDeleteButton(action: UIContextualAction) -> UISwipeActionsConfiguration {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 17.0, weight: .bold, scale: .large)
        action.image = UIImage(systemName: "trash", withConfiguration: largeConfig)?.withTintColor(.white, renderingMode: .alwaysTemplate).addBackgroundCircle(.systemRed)
        action.backgroundColor = .red
        action.title = "Удалить"
        let config = UISwipeActionsConfiguration(actions: [action])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    func deleteDataFromRealm(indexPath: IndexPath) {
        DispatchQueue.main.async {
            do {
                try self.realm.write {
                    self.realm.delete(self.forecastRealm[indexPath.section])
                }
            }
            catch let error {
                print("error when trying to delete data from Realm: \(error.localizedDescription)")
            }
        }
    }

    func locationButtonPressed(longitude: Double, latitude: Double) {
        currentWeatherService.getCurrentWeather(longitute: longitude, latitude: latitude, units: UserDefaults.standard.string(forKey: "units") ?? "metric", language: .ru) { currentWeatherResult in
            switch currentWeatherResult {
            case .success(let weatherData):
                let realmfactory = CurrentWeatherFactory.makeRealmModel(weatherData, cityName: weatherData.name)
                RealmWorker.shared.saveToDatabase(data: realmfactory)
                self.presenter?.presentWeatherInCity(data: realmfactory)
            case .failure(let error):
                print("error after location button pressed and getting current weather: \(error.localizedDescription)")
            }
        }
    }
    
    func search(city: String) {
        geoService.searchCity(city) { [weak self] cityResult in
            guard let self else { return }
            switch cityResult {
            case .success(let cityData):
                guard let localNames = cityData.first?.localNames?["ru"], let longitude = cityData.first?.lon, let latitude = cityData.first?.lat else { return }
                
                self.currentWeatherService.getCurrentWeather(longitute: longitude, latitude: latitude, units: UserDefaults.standard.string(forKey: "units") ?? "metric", language: .ru) { currentWeatherResult in
                    
                    switch currentWeatherResult {
                    case .success(let currentWeatherData):
                        let realmFactory = CurrentWeatherFactory.makeRealmModel(currentWeatherData, cityName: localNames)
                        RealmWorker.shared.saveToDatabase(data: realmFactory)
                        self.presenter?.presentWeatherInCity(data: realmFactory)
                    case .failure(let error):
                        print("error after searching city and trying to get current weather in \(localNames): \(error.localizedDescription)")
                    }
                    
                }
            case .failure(let error):
                print("error when searching city: \(error.localizedDescription)")
            }
        }
    }
    
    func updateWeatherIn(city: String, indexPath: IndexPath) {
        print(city)
        self.geoService.searchCity(city) { [weak self] cityResult in
            guard let self else { return }
            switch cityResult {
            case .success(let cityData):
                guard let localName = cityData.first?.localNames?["ru"], let longitude = cityData.first?.lon, let latitude = cityData.first?.lat else { return }
                self.currentWeatherService.getCurrentWeather(longitute: longitude, latitude: latitude, units: UserDefaults.standard.string(forKey: "units") ?? "metric", language: .ru) { [weak self] currentWeatherResult in
                    guard let self else { return }
                    switch currentWeatherResult {
                    case .success(let weatherData):
                        let realmFactory = CurrentWeatherFactory.makeRealmModel(weatherData, cityName: localName)
                        //TODO: Обновление инфы в Realm по indexPath
                        RealmWorker.shared.updateDataInRealm(dataArray: forecastRealm, indexPath: indexPath, currentWeatherModel: weatherData) { model in
                            self.presenter?.presentWeatherInCity(data: model)
                        }
                    case .failure(let error):
                        print("error when gettting current weather: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print("error when updating weather in city \(error.localizedDescription)")
            }
        }
    }
    
}
