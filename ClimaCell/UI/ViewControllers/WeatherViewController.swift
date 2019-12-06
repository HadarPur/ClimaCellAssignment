//
//  WeatherViewController.swift
//  ClimaCell
//
//  Created by Hadar Pur on 06/12/2019.
//  Copyright © 2019 Hadar Pur. All rights reserved.
//

import UIKit
import MapKit


class WeatherViewController: UIViewController {
    
    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    let weather = Weather()
    let caountries = Countries()
    let flags = Flags()
    let utils = FuncUtils()
    
    var chosenRecord: CountriesData.CountriesObj?
    var weather5NextDays = [ClimaCellAPI.ClimaCellObj]()
    var titleMap: String?
    
    var capital: String?
    var country: String?
    var flag: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        
        utils.showAlertActivityIndicator(viewController: self, msg: "Loading...")
        setupTitle()
        getWeather()
    }

    override func viewDidAppear(_ animated: Bool) {
        setupPinOnTheMap()
    }
    
    func getWeather() {
        weather.getWeater(area: chosenRecord!) { (array) in
            self.weather5NextDays = Array(array.prefix(5))
            print("Temp: \(self.weather5NextDays[0])")

            DispatchQueue.main.async {
                self.weatherTableView.reloadData()
                self.utils.hideAlertActivityIndicator(viewController: self)
            }
        }
    }
    
    func setupTitle() {
        if chosenRecord!.capital.isEmpty { capital = "None" } else { capital = chosenRecord!.capital}
        
        country = chosenRecord!.name!
        flag = flags.flagForCountry(country: chosenRecord!.alpha2Code)
        
        titleMap = "\(capital!), \(country!) \(flag!)"
        self.title = titleMap
    }
    
    func setupPinOnTheMap() {
        caountries.getLocationForSpecificCapital(capitalObj: chosenRecord!) { (location) in
            // 2
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            self.mapView.setRegion(region, animated: true)
                
            //3
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = self.capital!
            annotation.subtitle = "\(self.country!) \(self.flag!)"
            
            self.mapView.addAnnotation(annotation)

        }
    }
}

extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weather5NextDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell") as! WeatherCell
        let obj = weather5NextDays[indexPath.row]
        
        
        let date = obj.observation_time.value!
        let minTemp = obj.temp[0].min!.value!
        let maxTemp = obj.temp[1].max!.value!
        let unit = obj.temp[0].min!.units!
        let precipitationValue = obj.precipitation[0].max.value!
        let precipitationUnit = obj.precipitation[0].max.units!

        let text = "Date: \(date)\nMin Temp: \(minTemp) \(unit)\nMax Temp: \(maxTemp) \(unit)\nPrecipitation: \(precipitationValue) \(precipitationUnit)"
        cell.textLabel?.text = text

        return cell
    }
}
