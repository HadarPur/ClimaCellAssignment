//
//  ClimaCellAPI.swift
//  ClimaCell
//
//  Created by Hadar Pur on 06/12/2019.
//  Copyright © 2019 Hadar Pur. All rights reserved.
//

import UIKit
import CoreLocation

class ClimaCellAPI {
    
    public struct ClimaCellObj: Decodable {
        let lat: Float!
        let lon: Float!
        let observation_time: ObservationTime!
        let precipitation: [Precipitation]!
        let temp: [Temps]!
    }
    
    public struct ClimaCellObj6Hours: Decodable {
        let lat: Float!
        let lon: Float!
        let temp: Temp6!
        let observation_time: ObservationTime!
    }
    
    struct ObservationTime: Decodable {
        let value: String!
    }
    
    struct Precipitation: Decodable {
        let max: Max!
        let observation_time: String!
    }
    
    struct Max: Decodable {
        let units: String!
        let value: Double!
    }
    
    struct Temps: Decodable {
        let min: Temp?
        let max: Temp?
        let observation_time: String!
    }
    
    struct Temp: Decodable {
        let units: String!
        let value: Double!
    }
    
    struct Temp6: Decodable {
        let value: Double!
        let units: String!

    }
    
    let climaCellUrl = "https://api.climacell.co/v3/weather/forecast/daily"
    let climaCellUrl6Hours = "https://api.climacell.co/v3/weather/nowcast"
    
    var apiKey: String?
    
    func getDataFromClimaCellAPI(area: CountriesData.CountriesObj ,callback: @escaping (Array<ClimaCellObj>) -> (), callbackError: @escaping () -> ()) {
        self.getClimaCellKeys { (apiKey) in
            CountriesData().getCapitalMapLocation(capital: area.capital, country: area.name, locationCallback: { (location) in
                let lat = location.coordinate.latitude
                let lon = location.coordinate.longitude
                let areaCode = area.area!
                let basicURL = self.climaCellUrl
                let startTime = "now"
                let fields = "temp,precipitation"
                
                let objURL = "\(basicURL)?location_id=\(areaCode)&lat=\(lat)&lon=\(lon)&start_time=\(startTime)&unit_system=si&fields=\(fields)"
                self.getSession(url: objURL, apiKey: apiKey, callback: callback, callbackError: callbackError)
            }, callbackError: {
                callbackError()
            })
        }
    }
    
    func getDataFromClimaCellAPI6Hours(area: CountriesData.CountriesObj ,callback: @escaping (Array<ClimaCellObj6Hours>) -> (), callbackError: @escaping () -> ()) {
        self.getClimaCellKeys { (apiKey) in
            CountriesData().getCapitalMapLocation(capital: area.capital, country: area.name, locationCallback: { (location) in
                let lat = location.coordinate.latitude
                let lon = location.coordinate.longitude
                let areaCode = area.area!
                let basicURL = self.climaCellUrl6Hours
                let startTime = "now"
                let fields = "temp"
                let timestep = 1
                
                let objURL = "\(basicURL)?location_id=\(areaCode)&lat=\(lat)&lon=\(lon)&&timestep=\(timestep)start_time=\(startTime)&unit_system=si&fields=\(fields)"
                self.getSessionFor6Hours(url: objURL, apiKey: apiKey, callback: callback, callbackError: callbackError)
            }, callbackError: {
                callbackError()
            })
        }
    }
    
    private func getSession(url: String, apiKey: String, callback: @escaping (Array<ClimaCellObj>) -> (), callbackError: @escaping () -> ()) {
        // create the request
        guard let SNUrl = URL(string: url) else { return }
        
        var request = URLRequest(url: SNUrl)
        request.httpMethod = "GET"
        request.setValue("\(apiKey)", forHTTPHeaderField: "apikey")
        request.setValue("application/JSON", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            if ((error) != nil) {
                callbackError()
            }
            do {
                let decoder = JSONDecoder()
                let decodeResult = try decoder.decode([ClimaCellObj].self, from: data)
                
                callback(decodeResult)
            } catch let err {
                print("getSession Err: ", err)
                callbackError()
            }
        }.resume()
    }
    
    private func getSessionFor6Hours(url: String, apiKey: String, callback: @escaping (Array<ClimaCellObj6Hours>) -> (), callbackError: @escaping () -> ()) {
        // create the request
        guard let SNUrl = URL(string: url) else { return }
        
        var request = URLRequest(url: SNUrl)
        request.httpMethod = "GET"
        request.setValue("\(apiKey)", forHTTPHeaderField: "apikey")
        request.setValue("application/JSON", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            if ((error) != nil) {
                callbackError()
            }
            do {
                let decoder = JSONDecoder()
                let decodeResult = try decoder.decode([ClimaCellObj6Hours].self, from: data)
                
                callback(decodeResult)
            } catch let err {
                print("getSession Err: ", err)
                callbackError()
            }
        }.resume()
    }
    
    
    private func getClimaCellKeys(getAPIKeyCallback: @escaping (String) -> ()) {
        //get the path of the plist file
        guard let plistPath = Bundle.main.path(forResource: "SecretClimaCellData", ofType: "plist") else { return }
        //load the plist as data in memory
        guard let plistData = FileManager.default.contents(atPath: plistPath) else { return }
        //use the format of a property list (xml)
        var format = PropertyListSerialization.PropertyListFormat.xml
        //convert the plist data to a Swift Dictionary
        guard let  plistDict = try! PropertyListSerialization.propertyList(from: plistData, options: .mutableContainersAndLeaves, format: &format) as? [String : AnyObject] else { return }
        //access the values in the dictionary
        if let climaCellApiKey = plistDict["ClimaCellAPIKey"] as? String {
            getAPIKeyCallback(climaCellApiKey)
        }
    }
}
