//
//  SettingsInteractor.swift
//  WeatherApp_CleanSwift
//
//  Created by Илья Кузнецов on 19.01.2024.
//

import Foundation
import UIKit.UISegmentedControl

protocol SettingsScreenBusinessLogic {
    func titlesForSections(_ section: Int) -> String?
    func windSegmentedControlPressed(segment: UISegmentedControl)
    func pressureSegmentedPressed(segment: UISegmentedControl)
    func didSelectRowAt(indexPath: IndexPath)
}

class SettingsScreenInteractor {
    var presenter: SettingsScreenPresentationLogic?
    private var selectedIndexPath: Int?
}

extension SettingsScreenInteractor: SettingsScreenBusinessLogic {
    
    func didSelectRowAt(indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectedIndexPath = indexPath.row
            
            if indexPath.row == 0 {
                UserDefaults.standard.setValue(MeasurementsTypes.mertic.rawValue, forKey: "units")
            } else {
                UserDefaults.standard.setValue(MeasurementsTypes.imperial.rawValue, forKey: "units")
            }
            UserDefaults.standard.setValue(selectedIndexPath, forKey: "selectedItem")
            UserDefaults.standard.synchronize()
        }
    }
    
    func windSegmentedControlPressed(segment: UISegmentedControl) {
        let selectedParameter = segment.titleForSegment(at: segment.selectedSegmentIndex)
        UserDefaults.standard.set(selectedParameter, forKey: MeasurementsTypes.wind.rawValue)
        UserDefaults.standard.set(segment.selectedSegmentIndex, forKey: "windIndex")
    }
    
    func pressureSegmentedPressed(segment: UISegmentedControl) {
        let selectedParameter = segment.titleForSegment(at: segment.selectedSegmentIndex)
        UserDefaults.standard.set(selectedParameter, forKey: MeasurementsTypes.pressure.rawValue)
        UserDefaults.standard.set(segment.selectedSegmentIndex, forKey: "pressureIndex")
    }

    
    func titlesForSections(_ section: Int) -> String? {
        switch section {
        case 0:
            return TitlesForSections.temperature.rawValue
        case 1:
            return TitlesForSections.other.rawValue
        default:
            return ""
        }
    }
    
}
