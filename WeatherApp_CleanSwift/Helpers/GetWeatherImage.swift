//
//  GetWeatherImage.swift
//  WeatherApp_CleanSwift
//
//  Created by Илья Кузнецов on 18.01.2024.
//

import Foundation
import UIKit.UIImage

class GetWeatherImage {
    
    /// Функция для автоматического выбора картинки погоды, на основе ID погоды, приходящей с сервера
    /// - Parameters:
    ///   - id: ID погоды с сервера
    ///   - pod: символ "d" (day) или "n" (night). Выбирается либо дневная картинка, либо ночная
    /// - Returns: Возвращает полученную картинку
    class func weatherImages(id: Int, pod: String?) -> UIImage {
        guard let pod else {
            print("Не удалось определить картинку погоды по pod \(String(describing: pod))")
            return UIImage(named: "cloudy-weather")!
        }
        switch id {
        case 200...232:
            if pod == "n" {
                return UIImage(named: "night-storm")!
            } else {
                return UIImage(named: "storm")!
            }
        case 300...321:
            if pod == "n" {
                return UIImage(named: "night-clouds-sun")!
            } else {
                return UIImage(named: "rain")!
            }
        case 500...531:
            if pod == "n" {
                return UIImage(named: "night-rain")!
            } else {
                return UIImage(named: "rain")!
            }
        case 600...622:
            if pod == "n" {
                return UIImage(named: "night-snow")!
            } else {
                return UIImage(named: "snow")!
            }
        case 700...781:
            if pod == "n" {
                return UIImage(named: "night-foggy")!
            } else {
                return UIImage(named: "foggy")!
            }
        case 800:
            if pod == "n" {
                return UIImage(named: "night-moon")!
            } else {
                return UIImage(named: "sun")!
            }
        case 801:
            if pod == "n" {
                return UIImage(named: "night-cloudy")!
            } else {
                return UIImage(named: "cloudy-weather")!
            }
        case 802:
            if pod == "n" {
                return UIImage(named: "night-cloudy2")!
            } else {
                return UIImage(named: "cloudy")!
            }
        case 803:
            if pod == "n" {
                return UIImage(named: "night-cloudy")!
            } else {
                return UIImage(named: "cloudy-weather")!
            }
        case 804:
            if pod == "n" {
                return UIImage(named: "night-cloudy2")!
            } else {
                return UIImage(named: "cloudy")!
            }
        default:
            return UIImage(named: "cloudy-weather")!
        }
    }
}
