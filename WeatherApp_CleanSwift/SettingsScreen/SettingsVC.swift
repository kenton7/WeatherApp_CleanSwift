//
//  SettingsVC.swift
//  WeatherApp_CleanSwift
//
//  Created by Илья Кузнецов on 18.01.2024.
//

import UIKit

protocol SettingsViewControllerDisplayLogic: AnyObject {
    func displayTitlesForSections(_ section: Int) -> String?
}

class SettingsVC: UIViewController {
    
    var interactor = SettingsScreenInteractor()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .clear
        tableView.rowHeight = 60
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.cellID)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setConstraints()
        setup()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        view.backgroundColor = UIColor(red: 0.11, green: 0.16, blue: 0.22, alpha: 1)
    }
    
    private func setup() {
        let viewController = self
        let presenter = SettingsPresenter()
        let interactor = SettingsScreenInteractor()
        interactor.presenter = presenter
        presenter.settingsViewController = viewController
        viewController.interactor = interactor
    }
    
    @objc func windSegmentedControlPressed(segment: UISegmentedControl) {
        interactor.windSegmentedControlPressed(segment: segment)
    }
    
    @objc func pressureSegmentedPressed(segment: UISegmentedControl) {
        interactor.pressureSegmentedPressed(segment: segment)
    }
}

//MARK: - Констрейнты
extension SettingsVC {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
}

extension SettingsVC: SettingsViewControllerDisplayLogic {
    
    func displayTitlesForSections(_ section: Int) -> String? {
        return ""
    }
    
}

//MARK: - TableView
extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let inteactor = SettingsScreenInteractor()
        return interactor.titlesForSections(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.cellID, for: indexPath) as! SettingsTableViewCell
            cell.setupCell(indexPath: indexPath)
            return cell
        } else {
            let cell = OtherMeasurementsCell(style: .default, reuseIdentifier: OtherMeasurementsCell.cellID)
            cell.setupOtherMeasurementsCell(indexPath: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor.didSelectRowAt(indexPath: indexPath)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
