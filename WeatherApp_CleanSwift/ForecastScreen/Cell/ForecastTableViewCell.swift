//
//  ForecastTableViewCell.swift
//  WeatherApp_CleanSwift
//
//  Created by Илья Кузнецов on 19.01.2024.
//

import UIKit

final class ForecastTableViewCell: UITableViewCell {

    static let cellID = "ForecastTableViewCell"
    
    lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "--"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    lazy var weatherImage: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "cloudy-weather")
        return view
    }()
    
    lazy var weatherDescription: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    lazy var minTemp: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var maxTemp: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    var maxTempTrailingConstraint: NSLayoutConstraint!
    var minTempTrailingConstraint: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        clipsToBounds = false
        backgroundColor = .clear
        alpha = 0.8
        layer.cornerRadius = 15
        isUserInteractionEnabled = false
        selectionStyle = .none
        
        addSubview(dayLabel)
        addSubview(weatherImage)
        addSubview(weatherDescription)
        addSubview(minTemp)
        addSubview(maxTemp)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            dayLabel.widthAnchor.constraint(equalToConstant: 110),
            dayLabel.centerYAnchor.constraint(equalTo: weatherImage.centerYAnchor),
            
            weatherImage.heightAnchor.constraint(equalToConstant: 40),
            weatherImage.widthAnchor.constraint(equalToConstant: 40),
            weatherImage.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 5),
            
            weatherDescription.leadingAnchor.constraint(equalTo: weatherImage.trailingAnchor, constant: 5),
            weatherDescription.centerYAnchor.constraint(equalTo: weatherImage.centerYAnchor),
            weatherDescription.widthAnchor.constraint(equalToConstant: 100),
            weatherDescription.heightAnchor.constraint(equalToConstant: 40),
            
            maxTemp.centerYAnchor.constraint(equalTo: weatherImage.centerYAnchor),
            
            minTemp.centerYAnchor.constraint(equalTo: weatherImage.centerYAnchor),
        ])
        maxTempTrailingConstraint = maxTemp.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        maxTempTrailingConstraint.isActive = true
        minTempTrailingConstraint = minTemp.trailingAnchor.constraint(equalTo: maxTemp.leadingAnchor, constant: -5)
        minTempTrailingConstraint.isActive = true
        
        maxTemp.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        minTemp.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
    }
    
    func setupCell(_ model: ForecastModelNew) {
        weatherDescription.text = model.weatherDescriptionComputed
        dayLabel.text = model.date
        minTemp.text = "\(model.minTemp)°"
        maxTemp.text = "\(model.maxTemp)°"
        weatherImage.image = GetWeatherImage.weatherImages(id: model.weatherID, pod: model.dayOrNight)
    }
}

