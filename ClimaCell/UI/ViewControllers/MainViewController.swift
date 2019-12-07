//
//  MainViewController.swift
//  ClimaCell
//
//  Created by Hadar Pur on 06/12/2019.
//  Copyright © 2019 Hadar Pur. All rights reserved.
//

import UIKit
import MapKit

// The main screen that shows the all capitals, countries and flags
class MainViewController: UIViewController {
    
    @IBOutlet weak var capitalsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let mCountries = Countries.shared
    var searchCapital = [CountriesData.CountriesObj]()
    let flags = Flags()

    var searching = false
    let mapView = MKMapView()
    var isMapExist = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        popupViewControllerFromStack()
       
        capitalsTableView.delegate=self
        capitalsTableView.dataSource=self
        searchBar.delegate = self
        mapView.delegate = self
        
        self.navigationController?.isNavigationBarHidden = false
        self.title = "ClimaCell"
        
        setupMap()
        self.hideKeyboardWhenTappedAround()
        setupBarButtons()
    }
    
    func popupViewControllerFromStack() {
        var navigationArray = self.navigationController?.viewControllers //To get all UIViewController stack as Array
        navigationArray!.remove(at: (navigationArray?.count)! - 2) // To remove previous UIViewController
        self.navigationController?.viewControllers = navigationArray!
    }
    
    func setupBarButtons() {
        let changeBarButtonItem = UIBarButtonItem(title: "Change", style: .done, target: self, action: #selector(ChangeTableToMap))
        self.navigationItem.rightBarButtonItem  = changeBarButtonItem
    }
    
    @objc func ChangeTableToMap(){
        if isMapExist {
            isMapExist = false
            DispatchQueue.main.async {
                self.mapView.removeFromSuperview()
            }
        } else {
            DispatchQueue.main.async {
                self.view.addSubview(self.mapView)
            }
            isMapExist = true
        }
    }
    
    func setupMap() {
        
        let leftMargin:CGFloat = 0
        let topMargin:CGFloat = 0
        let mapWidth:CGFloat = view.frame.size.width
        let mapHeight:CGFloat = view.frame.size.height
        
        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        // Or, if needed, we can position map in the center of the view
        mapView.center = view.center
        
        setupPinOnTheMap()
    }
    
    func setupPinOnTheMap() {
        for chosenRecord in mCountries.getCountries() {
                        
            if !chosenRecord.latlng.isEmpty {
                Map().setupPin(record: chosenRecord, map: self.mapView)
            }
            else {
                mCountries.getLocationForSpecificCapital(capitalObj: chosenRecord, callback: { (location) in
                    print("Done set pin on the map")

                    let latlng: [Double] = [location.coordinate.latitude, location.coordinate.longitude]
                    
                    let newRecord = CountriesData.CountriesObj(name: chosenRecord.name, alpha2Code: chosenRecord.alpha2Code, capital: chosenRecord.capital, latlng: latlng)
                    
                    Map().setupPin(record: newRecord, map: self.mapView)
                    
                }, callbackError: {
                    DispatchQueue.main.async {
                        FuncUtils().showAlertMessage(vc: self, title: "Some error has occurred", message: "There is a problem to set pin on the map for \(chosenRecord.name!), please try later.", cancelButtonTitle: "Ok")
                    }
                })
            }            
        }
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

// Map view delegate
extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let pinTitle = "\(String(((view.annotation?.title)!)!))"
        let capitalsArray = mCountries.getCountries()
        
        
        let chosenCapital = capitalsArray.filter({$0.name.lowercased().prefix(pinTitle.count) == pinTitle.lowercased()})
        
        print("chosenCapital: \(chosenCapital)")

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let weatherViewController = storyBoard.instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController

        guard weatherViewController != nil else {
            return
        }

        weatherViewController?.chosenRecord = chosenCapital[0]

        DispatchQueue.main.async {
            self.navigationController?.pushViewController(weatherViewController!, animated: true)
        }
        
    }
    
}
