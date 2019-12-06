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
    
    var chosenRecord: CountriesData.CountriesObj?
    var weather5NextDays = [ClimaCellAPI.ClimaCellObj]()
    var titleMap: String?
    
    var capital: String?
    var country: String?
    var flag: String?
    var isInCelsius = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        
        setupTitle()
        getWeather()
        
        let logoutBarButtonItem = UIBarButtonItem(title: "Change", style: .done, target: self, action: #selector(ChangeTempUnits))
        self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
    }

    @objc func ChangeTempUnits(){
        if isInCelsius {
            isInCelsius = false
        } else {
           isInCelsius = true
        }
        self.weatherTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupPinOnTheMap()
    }
    
    func getWeather() {
        print("Start reading weather.")
        weather.getWeather(area: chosenRecord!, callback: { (weatherArray) in
            print("Done reading weather.")

            self.weather5NextDays = Array(weatherArray.prefix(5))

            DispatchQueue.main.async {
                self.weatherTableView.reloadData()
            }
        }, callbackError: {
            print("Done reading weather.")

            DispatchQueue.main.async {
                FuncUtils().showAlertMessage(vc: self, title: "Some error has occurred", message: "There is a problem to read the weather, please try later.", cancelButtonTitle: "Ok")
            }
        })
    }
    
    func setupTitle() {
        if chosenRecord!.capital.isEmpty { capital = "None" } else { capital = chosenRecord!.capital}
        
        country = chosenRecord!.name!
        flag = flags.flagForCountry(country: chosenRecord!.alpha2Code)
        
        titleMap = "\(capital!), \(country!) \(flag!)"
        self.title = titleMap
    }
    
    func setupPinOnTheMap() {
        print("Start set pin on the map.")
        caountries.getLocationForSpecificCapital(capitalObj: chosenRecord!, callback: { (location) in
            print("Done set pin on the map")

              let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
              let region = MKCoordinateRegion(center: location.coordinate, span: span)
              self.mapView.setRegion(region, animated: true)
                  
              let annotation = MKPointAnnotation()
              annotation.coordinate = location.coordinate
              annotation.title = self.capital!
              annotation.subtitle = "\(self.country!) \(self.flag!)"
              
              self.mapView.addAnnotation(annotation)
        }, callbackError: {
            DispatchQueue.main.async {
                FuncUtils().showAlertMessage(vc: self, title: "Some error has occurred", message: "There is a problem to read the weather, please try later.", cancelButtonTitle: "Ok")
            }
        })
    }
    
    func temperatureInFahrenheit(temperature: Double) -> Double {
          let fahrenheit = (temperature * 9.0) / 5.0 + 32.0
          return fahrenheit
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
        let precipitationValue = obj.precipitation[0].max.value!
        let precipitationUnit = obj.precipitation[0].max.units!

        var minTemp: Double?
        var maxTemp: Double?
        var unit: String?
        
        if (isInCelsius) {
            minTemp = obj.temp[0].min!.value!
            maxTemp = obj.temp[1].max!.value!
            unit = obj.temp[0].min!.units!
        } else {
            minTemp = temperatureInFahrenheit(temperature: obj.temp[0].min!.value!)
            maxTemp = temperatureInFahrenheit(temperature: obj.temp[1].max!.value!)
            unit = "F"
        }
        let text = "Date: \(date)\nMin Temp: \(minTemp!) \(unit!)\nMax Temp: \(maxTemp!) \(unit!)\nPrecipitation: \(precipitationValue) \(precipitationUnit)"
        cell.textLabel?.text = text

        return cell
    }
}
