//
//  RealmWorker.swift
//  WeatherApp_CleanSwift
//
//  Created by Илья Кузнецов on 19.01.2024.
//

import Foundation
import RealmSwift

protocol RealmWorkerBusinessLogic {
    func updateDataInRealm(dataArray: Results<RealmModel>, indexPath: IndexPath, currentWeatherModel: CurrentWeatherModel, completion: @escaping (([RealmModel]) -> Void) )
    func saveToDatabase(data: [RealmModel])
}

class RealmWorker {
    
    static let shared = RealmWorker()
    
    private init() {}
    
    lazy var realm = try! Realm()
}

extension RealmWorker: RealmWorkerBusinessLogic {
    
    func saveToDatabase(data: [RealmModel]) {
        DispatchQueue.main.async {
            do {
                try self.realm.write {
                    self.realm.add(data)
                }
            }
            catch let error {
                print("error when saving data in Realm: \(error.localizedDescription)")
            }
        }
    }
    
    func updateDataInRealm(dataArray: Results<RealmModel>, indexPath: IndexPath, currentWeatherModel: CurrentWeatherModel, completion: @escaping (([RealmModel]) -> Void)) {
        if dataArray[indexPath.section].temp != currentWeatherModel.main?.temp?.rounded() 
            || dataArray[indexPath.section].id != currentWeatherModel.weather?.first?.id ?? 803
            || dataArray[indexPath.section].weatherDescription != currentWeatherModel.weather?.first?.description
            || dataArray[indexPath.section].dayOrNight != String(currentWeatherModel.weather?.first?.icon?.last ?? "d") {
            DispatchQueue.main.async {
                do {
                    try self.realm.write {
                        dataArray[indexPath.section].temp = currentWeatherModel.main?.temp?.rounded() ?? 0.0
                        dataArray[indexPath.section].id = currentWeatherModel.weather?[0].id ?? 803
                        dataArray[indexPath.section].dayOrNight = String(currentWeatherModel.weather?[0].icon?.last ?? "d")
                        dataArray[indexPath.section].weatherDescription = currentWeatherModel.weather?[0].description ?? ""
                    }
                }
                catch let error {
                    print("error when updating data in Realm: \(error.localizedDescription)")
                }
            }
            let factory = CurrentWeatherFactory.makeUpdatedRealmModel(dataArray)
            completion(factory)
        } else {
            return
        }
    }
}
