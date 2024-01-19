//
//  WeatherCollectionViewCell.swift
//  WeatherApp_CleanSwift
//
//  Created by Илья Кузнецов on 18.01.2024.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "WeatherCollectionViewCell"
    
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .backgroundColorTabBar
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0.9
        return imageView
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var weatherIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "sun")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backgroundColorTabBar
        view.alpha = 0.8
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stackView)
        stackView.layer.cornerRadius = 8
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(weatherIcon)
        stackView.addArrangedSubview(temperatureLabel)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            weatherIcon.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            weatherIcon.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            weatherIcon.heightAnchor.constraint(equalToConstant: 30),
            weatherIcon.widthAnchor.constraint(equalToConstant: 30),
            
            temperatureLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0),
            temperatureLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(viewModel: MainCollectionViewCellViewModel) {
        weatherIcon.image = viewModel.image
        temperatureLabel.text = viewModel.temperature + "°"
        timeLabel.text = viewModel.time
    }
}
