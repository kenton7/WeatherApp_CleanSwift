//
//  SearchVC.swift
//  WeatherApp_CleanSwift
//
//  Created by Илья Кузнецов on 18.01.2024.
//

import UIKit
import RealmSwift
import CoreLocation

protocol SearchViewControllerDisplayLogic: AnyObject {
    func displayUpdatedWeather(data: [RealmModel])
    func displayUpdatedWeather(data: Results<RealmModel>)
}

class SearchVC: UIViewController {

    private var interactor: SearchScreenBusinessLogic?
    private var dataToDisplay = [RealmModel]()
    let locationManager = CLLocationManager()
    var coordinates: Coordinates?
    private lazy var realm = try! Realm()
    var forecastRealm: Results<RealmModel>!
    
    private lazy var locationButton: UIButton = {
       let button = UIButton()
        button.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.layer.backgroundColor = UIColor(red: 0.322, green: 0.239, blue: 0.498, alpha: 1).cgColor
        button.layer.borderColor = UIColor.green.cgColor
        button.setImage(UIImage(named: "location"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(locationButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .clear
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.cellID)
        return tableView
    }()
    
    lazy var spinner: CustomSpinner = {
        let spinner = CustomSpinner(squareLength: 100)
        spinner.isHidden = true
        return spinner
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.startUpdatingLocation()
            }
        }
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
        setupViews()
        setupSearchBar()
        setConstraints()
        setup()
        
        //forecastRealm = self.realm.objects(RealmModel.self)
    }
    
    @objc private func locationButtonPressed() {
        interactor?.locationButtonPressed(longitude: coordinates?.longitude ?? 0.0, latitude: coordinates?.latitude ?? 0.0)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func setup() {
        let viewController = self
        let presenter = SearchScreenPresenter()
        let interactor = SearchScreenInteractor()
        interactor.presenter = presenter
        interactor.forecastRealm = self.realm.objects(RealmModel.self)
        presenter.searchViewController = viewController
        viewController.interactor = interactor
    }

    func setupViews() {
        view.backgroundColor = UIColor(red: 0.11, green: 0.16, blue: 0.22, alpha: 1)
        view.addSubview(locationButton)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(spinner)
    }
}

//MARK: - Констрейнты
extension SearchVC {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            locationButton.widthAnchor.constraint(equalToConstant: 55),
            locationButton.heightAnchor.constraint(equalToConstant: 55),
            locationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            locationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            
            searchBar.centerYAnchor.constraint(equalTo: locationButton.centerYAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: locationButton.safeAreaLayoutGuide.leadingAnchor, constant: -10),
            
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
}

//MARK: - SearchViewControllerDisplayLogic
extension SearchVC: SearchViewControllerDisplayLogic {
    
    func displayUpdatedWeather(data: [RealmModel]) {
        dataToDisplay.removeAll()
        dataToDisplay.append(contentsOf: data)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func displayUpdatedWeather(data: Results<RealmModel>) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - Location
extension SearchVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        coordinates = Coordinates(latitude: locValue.latitude, longitude: locValue.longitude)
        manager.stopUpdatingLocation()
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let interactor = SearchScreenInteractor()
        interactor.forecastRealm = self.realm.objects(RealmModel.self)
        self.forecastRealm = interactor.forecastRealm
        return interactor.forecastRealm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.cellID, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        let viewModel = forecastRealm[indexPath.section]
        interactor?.updateWeatherIn(city: viewModel.cityName, indexPath: indexPath)
        cell.setupCell(viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.isUserInteractionEnabled = false
        header.backgroundColor = .clear
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let header = UIView()
        header.isUserInteractionEnabled = false
        header.backgroundColor = .clear
        header.clipsToBounds = false
        return header
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: nil) { UIContextualAction, _, completion in
            self.interactor?.deleteDataFromRealm(indexPath: indexPath)
            completion(true)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        return interactor?.customDeleteButton(action: delete)
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? SearchTableViewCell {
            cell.layer.cornerRadius = 15
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let factory: ViewControllerFactory = ForecastViewControllerFactory()
//        let forecastVC = factory.makeForecastViewController() as! ForecastVC
//        forecastVC.hidesBottomBarWhenPushed = false
//        let transferData = viewModel.forecastRealm[indexPath.section]
//        forecastVC.longitude = transferData.longitude
//        forecastVC.latitude = transferData.latitude
//        forecastVC.weatherImage.image = GetWeatherImage.weatherImages(id: transferData.id, pod: transferData.dayOrNight)
////        viewModel.didSelectRow(indexPath: indexPath, data: viewModel.forecastRealm[indexPath.section])
//        navigationController?.pushViewController(forecastVC, animated: true)
//    }
}

extension SearchVC: UISearchBarDelegate {
    
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.layer.cornerRadius = 15
        searchBar.searchTextField.backgroundColor = UIColor(red: 0.322, green: 0.239, blue: 0.498, alpha: 1)
        searchBar.barTintColor = UIColor(red: 0.322, green: 0.239, blue: 0.498, alpha: 1)
        searchBar.searchTextField.attributedPlaceholder =  NSAttributedString.init(string: "Поиск города", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])
        searchBar.searchTextField.leftView?.tintColor = .white
        searchBar.searchTextField.rightView?.tintColor = .white
        searchBar.clipsToBounds = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchingCity = searchBar.text else { return }
        searchBar.searchTextField.autocorrectionType = .yes
        UserDefaults.standard.set(searchingCity, forKey: "city")
        
        interactor?.search(city: searchingCity)
        searchBar.text = ""
        searchBar.endEditing(true)
    }
}
