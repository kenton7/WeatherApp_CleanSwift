//
//  SettingsTableViewCell.swift
//  WeatherApp_CleanSwift
//
//  Created by Илья Кузнецов on 19.01.2024.
//

import UIKit

final class SettingsTableViewCell: UITableViewCell {
    
    static let cellID = "SettingsTableViewCell"
    
    private lazy var temperatureLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layer.cornerRadius = 15
        backgroundColor = .backgroundColorTabBar
        addSubview(temperatureLabel)
        selectionStyle = .none
        tintColor = .white
        
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            temperatureLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            temperatureLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            temperatureLabel.heightAnchor.constraint(equalToConstant: 30),
            temperatureLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(indexPath: IndexPath) {
        temperatureLabel.text = MeasureType.allCases[indexPath.row].rawValue
        if indexPath.row == UserDefaults.standard.integer(forKey: "selectedItem") {
            accessoryType = .checkmark
        } else {
            accessoryType = .none
        }
    }
}
