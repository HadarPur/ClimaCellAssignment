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
    var searchResults = [CountriesData.CountriesObj]()
    let flags = Flags()
    
    var searching = false
    lazy var mapView = MKMapView()
    var isMapExist = false
    var isDoneLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        capitalsTableView.delegate=self
        capitalsTableView.dataSource=self
        searchBar.delegate = self
        mapView.delegate = self
        
        capitalsTableView.keyboardDismissMode = .interactive
        
        self.navigationController?.isNavigationBarHidden = false
        self.title = "ClimaCell"
        
        self.hideKeyboardWhenTappedAround()
        setupBarButtons()


        let vc = LoadingViewController.instantiate()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isDoneLoading {
            setupMap()
            isDoneLoading = true
        }
        capitalsTableView.reloadData()
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
    
    func moveToWeatherVC(chosenRecord: CountriesData.CountriesObj){
        print("chosenCapital: \(chosenRecord)")
        
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
    
    func setLocation(chosenRecord: CountriesData.CountriesObj) {
        mCountries.getLocationForSpecificCapital(capitalObj: chosenRecord, callback: { (location) in
            print("Done set pin on the map")
            
            let latlng: [Double] = [location.coordinate.latitude, location.coordinate.longitude]
            
            let newRecord = CountriesData.CountriesObj(name: chosenRecord.name, alpha2Code: chosenRecord.alpha2Code, capital: chosenRecord.capital, latlng: latlng)
            
            self.moveToWeatherVC(chosenRecord: newRecord)
            
        }, callbackError: {
            DispatchQueue.main.async {
                FuncUtils().showAlertMessage(vc: self, title: "Some error has occurred", message: "There is a problem to set pin on the map for \(chosenRecord.name!), please try later.", cancelButtonTitle: "Ok")
            }
        })
    }
}

// Table view delegates
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching { return searchResults.count }
        return mCountries.getCountries().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CapitalCell") as! CapitalCell
        
        var record: CountriesData.CountriesObj?
        var capital: String?
        var country: String?
        var flag: String?
        
        if searching == true {
            record = searchResults[indexPath.row]
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
        
        if !chosenRecord.latlng.isEmpty {
            moveToWeatherVC(chosenRecord: chosenRecord)
        } else {
            setLocation(chosenRecord: chosenRecord)
        }
    }
}

// Search bar delegate
extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let capitalsArray = mCountries.getCountries()
        
        searchResults = capitalsArray.filter({
            let phrase = searchText.lowercased()
            return $0.capital.lowercased().contains(phrase) || $0.name.lowercased().contains(phrase) || $0.alpha2Code.lowercased().contains(phrase)
        })
        
        searching = true
        capitalsTableView.reloadData()
    }
}

// Map view delegate
extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let pinTitle = "\(String(((view.annotation?.title)!)!))"
        let capitalsArray = mCountries.getCountries()
        
        let chosenRecord = capitalsArray.filter({$0.name.lowercased().prefix(pinTitle.count) == pinTitle.lowercased()})
        
        if !chosenRecord[0].latlng.isEmpty {
            moveToWeatherVC(chosenRecord: chosenRecord[0])
        } else {
            setLocation(chosenRecord: chosenRecord[0])
        }
    }
}
