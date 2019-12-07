//
//  MainViewController.swift
//  ClimaCell
//
//  Created by Hadar Pur on 06/12/2019.
//  Copyright © 2019 Hadar Pur. All rights reserved.
//

import UIKit

// The main screen that shows the all capitals, countries and flags
class MainViewController: UIViewController {
    
    @IBOutlet weak var capitalsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let mCountries = Countries.shared
    var searchCapital = [CountriesData.CountriesObj]()
    let flags = Flags()
    
    var searching = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        popupViewControllerFromStack()
       
        capitalsTableView.delegate=self
        capitalsTableView.dataSource=self
        searchBar.delegate = self
        
        self.navigationController?.isNavigationBarHidden = false
        self.title = "ClimaCell"
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func popupViewControllerFromStack() {
        var navigationArray = self.navigationController?.viewControllers //To get all UIViewController stack as Array
        navigationArray!.remove(at: (navigationArray?.count)! - 2) // To remove previous UIViewController
        self.navigationController?.viewControllers = navigationArray!
    }
}

// Table view delegates
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching { return searchCapital.count }
        return mCountries.getCountries().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CapitalCell") as! CapitalCell
        
        var record: CountriesData.CountriesObj?
        var capital: String?
        var country: String?
        var flag: String?
        
        if searching == true {
            record = searchCapital[indexPath.row]
        } else {
            record = mCountries.getCountries()[indexPath.row]
        }
        
        if record!.capital.isEmpty { capital = "None" } else { capital = record!.capital}
        
        country = record!.name
        flag = flags.flagForCountry(country: record!.alpha2Code)
        cell.textLabel?.text = "\(capital!), \(country!) \(flag!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chosenRecord = mCountries.getCountries()[indexPath.row]
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let weatherViewController = storyBoard.instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController
        
        guard weatherViewController != nil else {
            return
        }
        
        weatherViewController?.chosenRecord = chosenRecord
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(weatherViewController!, animated: true)
        }

    }
}

// Search bar delegate
extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let capitalsArray = mCountries.getCountries()
        
        searchCapital = capitalsArray.filter({$0.capital.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        capitalsTableView.reloadData()
    }
}
