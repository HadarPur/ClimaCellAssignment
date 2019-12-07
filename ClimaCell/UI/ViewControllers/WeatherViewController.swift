//
//  WeatherViewController.swift
//  ClimaCell
//
//  Created by Hadar Pur on 06/12/2019.
//  Copyright © 2019 Hadar Pur. All rights reserved.
//

import UIKit
import MapKit
import ScrollableGraphView
import FireworksKit

// The weather screen who shows tableview with the weather for the next 5 days, graph with the temp for the next 6 hours, and the capital location on the map
class WeatherViewController: UIViewController {
    
    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var graphView: ScrollableGraphView!
    
    let mCountriesWeather = Weather.shared

    let caountries = Countries()
    let flags = Flags()
    var fireworksView: FireworksView?
    
    var numberOfItems: Int?
    
    var chosenRecord: CountriesData.CountriesObj?
    var weather5NextDays = [ClimaCellAPI.ClimaCellObj]()
    var weather6NextHours = [ClimaCellAPI.ClimaCellObj6Hours]()
    
    var titleMap: String?
    var anumationIsSet = false
    
    var capital: String?
    var country: String?
    var flag: String?
    var isInCelsius = true
    var tempAtrrayC = [Double]()
    var tempAtrrayF = [Double]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        graphView.dataSource = self
        
        setupTitle()
        getWeather()
        setupArrays()
        setupGraph(tempArray: tempAtrrayC)
        setupWeatherAnim()

        setupBarButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupPinOnTheMap()
    }
    
    func setupWeatherAnim() {
        fireworksView = FireworksView(frame: view.frame)
    }
    
    func setupBarButtons() {
        let changeBarButtonItem = UIBarButtonItem(title: "Change", style: .done, target: self, action: #selector(ChangeTempUnits))
        self.navigationItem.rightBarButtonItem  = changeBarButtonItem
    }
    
    @objc func ChangeTempUnits(){
        if isInCelsius {
            setupGraph(tempArray: self.tempAtrrayF)
            isInCelsius = false
        } else {
            setupGraph(tempArray: self.tempAtrrayC)
            isInCelsius = true
        }
        
        DispatchQueue.main.async {
            self.weatherTableView.reloadData()
            self.graphView.reload()
        }
    }
    
    func setupArrays() {
        for index in -100...100 {
            tempAtrrayC.append(Double(index))
        }
        
        for index in -50...150 {
            tempAtrrayF.append(Double(index))
        }
    }
    
    func setupGraph(tempArray: [Double]) {
        // Setup the line plot.
        let linePlot = LinePlot(identifier: "darkLine")
        
        linePlot.lineWidth = 1
        linePlot.lineColor = UIColor.gray
        linePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        
        linePlot.shouldFill = true
        linePlot.fillType = ScrollableGraphViewFillType.gradient
        linePlot.fillGradientType = ScrollableGraphViewGradientType.linear
        linePlot.fillGradientStartColor = UIColor.darkGray
        linePlot.fillGradientEndColor = UIColor.lightGray
        
        linePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        let dotPlot = DotPlot(identifier: "darkLineDot") // Add dots as well.
        dotPlot.dataPointSize = 2
        dotPlot.dataPointFillColor = UIColor.white
        
        dotPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        // Setup the reference lines.
        let referenceLines = ReferenceLines()
        
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.white
        
        referenceLines.positionType = .absolute
        // Reference lines will be shown at these values on the y-axis.
        referenceLines.absolutePositions = tempArray
        referenceLines.includeMinMax = false
        
        referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)
        
        // Setup the graph
        graphView.backgroundFillColor = UIColor.lightGray
        graphView.dataPointSpacing = 80
        
        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true
        graphView.shouldRangeAlwaysStartAtZero = true
        
        graphView.rangeMax = 50
        
        // Add everything to the graph.
        graphView.addReferenceLines(referenceLines: referenceLines)
        graphView.addPlot(plot: linePlot)
        graphView.addPlot(plot: dotPlot)
        
    }
    
    func getWeather() {
        print("Start reading weather.")
    
        let dailyObj = mCountriesWeather.getCapitalDailyWeather(capitalObj: chosenRecord!)
        if !dailyObj.isEmpty {
            print("Reading local.")
            self.weather5NextDays = dailyObj
            
            DispatchQueue.main.async {
                self.weatherTableView.reloadData()
            }
        } else {
            print("Reading from endpoind.")
            readDailyData()
        }
        
        mCountriesWeather.getWeatherFor6Hours(capitalObj: chosenRecord!, callback: { (weatherArray) in
            print("Done reading weather 6 hours.")
            self.weather6NextHours = weatherArray
            self.numberOfItems = self.weather6NextHours.count
            
            DispatchQueue.main.async {
                self.graphView.reload()
            }
            
        }, callbackError: {
            print("Done reading weather 6 hours with error.")
            
            DispatchQueue.main.async {
                FuncUtils().showAlertMessage(vc: self, title: "Some error has occurred", message: "There is a problem to read the weather, please try later.", cancelButtonTitle: "Ok")
            }
        })
    }
    
    func readDailyData() {
        mCountriesWeather.getWeather(capitalObj: chosenRecord!, callback: { (weatherArray) in
            print("Done reading weather.")
            
            self.weather5NextDays = weatherArray
            
            DispatchQueue.main.async {
                self.weatherTableView.reloadData()
            }
        }, callbackError: {
            print("Done reading weather with error.")
            
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
        if !chosenRecord!.latlng.isEmpty {
            Map().setupPin(record: chosenRecord!, map: mapView)
        }
        else {
            caountries.getLocationForSpecificCapital(capitalObj: chosenRecord!, callback: { (location) in
                print("Done set pin on the map")

                let latlng: [Double] = [location.coordinate.latitude, location.coordinate.longitude]
                
                let newRecord = CountriesData.CountriesObj(name: self.chosenRecord!.name, alpha2Code: self.chosenRecord!.alpha2Code, capital: self.chosenRecord!.capital, latlng: latlng)
                
                Map().setupPin(record: newRecord, map: self.mapView)

            }, callbackError: {
                DispatchQueue.main.async {
                    FuncUtils().showAlertMessage(vc: self, title: "Some error has occurred", message: "There is a problem to set pin on the map for \(self.chosenRecord!.name!), please try later.", cancelButtonTitle: "Ok")
                }
            })
        }
    }
    
    func temperatureInFahrenheit(temperature: Double) -> Double {
        let fahrenheit = (temperature * 9.0) / 5.0 + 32.0
        return fahrenheit
    }
    
    private func generateRandomData(_ numberOfItems: Int, max: Double, shouldIncludeOutliers: Bool = true) -> [Double] {
        var data = [Double]()
        for _ in 0 ..< numberOfItems {
            var randomNumber = Double(arc4random()).truncatingRemainder(dividingBy: max)
            
            if(shouldIncludeOutliers) {
                if(arc4random() % 100 < 10) {
                    randomNumber *= 3
                }
            }
            data.append(randomNumber)
        }
        return data
    }
}

// UITable view extentions
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
        
        var minTemp = obj.temp[0].min!.value!
        var maxTemp = obj.temp[1].max!.value!
        var unit = obj.temp[0].min!.units!
        
        if !anumationIsSet {
            var particleEffect: ParticleEffect!
            if precipitationValue > 0.0 && minTemp > 5.0 { particleEffect = ParticleEffect(type: .rain) }
            else if precipitationValue > 0.0 && maxTemp < 5.0 { particleEffect = ParticleEffect(type: .snow) }
            else if maxTemp > 25.0 && precipitationValue == 0.0 { particleEffect = ParticleEffect(type: .fire) }
            else { particleEffect = ParticleEffect(type: .smoke) }
            anumationIsSet = true
            fireworksView!.particleEffect = particleEffect
            view.addSubview(fireworksView!)
        }
        
        if !isInCelsius {
            minTemp = temperatureInFahrenheit(temperature: obj.temp[0].min!.value!)
            maxTemp = temperatureInFahrenheit(temperature: obj.temp[1].max!.value!)
            unit = "F"
        }
    
        let text = "Date: \(date)\nMin Temp: \(minTemp) \(unit)\nMax Temp: \(maxTemp) \(unit)\nPrecipitation: \(precipitationValue) \(precipitationUnit)"
        cell.textLabel?.text = text
        
        return cell
    }
}

// ScrollableGraphView extentions
extension WeatherViewController: ScrollableGraphViewDataSource {
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        if isInCelsius {
            return self.weather6NextHours[pointIndex].temp.value
        }
        return temperatureInFahrenheit(temperature: self.weather6NextHours[pointIndex].temp.value)
    }
    
    func label(atIndex pointIndex: Int) -> String {
        
        let dateString = "\(self.weather6NextHours[pointIndex].observation_time.value!)"
 
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: dateString)

        dateFormatter.dateFormat = "HH:mm"
        let goodDate = dateFormatter.string(from: date!)
        
        return "\(goodDate)"
    }
    
    func numberOfPoints() -> Int {
        return numberOfItems ?? 0
    }
}

