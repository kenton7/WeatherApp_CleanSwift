//
//  SearchScreenPresenter.swift
//  WeatherApp_CleanSwift
//
//  Created by Илья Кузнецов on 19.01.2024.
//

import Foundation
import RealmSwift

protocol SearchScreenPresentationLogic {
    func presentWeatherInCity(data: [RealmModel])
    func presentUpdatedWeatherInCity(data: Results<RealmModel>)
}

class SearchScreenPresenter {
    weak var searchViewController: SearchViewControllerDisplayLogic?
}

//MARK:
extension SearchScreenPresenter: SearchScreenPresentationLogic {
    
    func presentWeatherInCity(data: [RealmModel]) {
        searchViewController?.displayUpdatedWeather(data: data)
    }
    
    func presentUpdatedWeatherInCity(data: Results<RealmModel>) {
        searchViewController?.displayUpdatedWeather(data: data)
    }
}
