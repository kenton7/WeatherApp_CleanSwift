//
//  SettingsPresenter.swift
//  WeatherApp_CleanSwift
//
//  Created by Илья Кузнецов on 19.01.2024.
//

import Foundation

protocol SettingsScreenPresentationLogic {
    func titlesForSections(_ section: Int) -> String?
}

class SettingsPresenter {
    weak var settingsViewController: SettingsViewControllerDisplayLogic?
}

extension SettingsPresenter: SettingsScreenPresentationLogic {
    
    func titlesForSections(_ section: Int) -> String? {
        settingsViewController?.displayTitlesForSections(section)
    }
}
