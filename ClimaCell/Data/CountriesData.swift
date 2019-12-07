//
//  CountriesData.swift
//  ClimaCell
//
//  Created by Hadar Pur on 06/12/2019.
//  Copyright © 2019 Hadar Pur. All rights reserved.
//

import Foundation
import CoreLocation

class CountriesData {
    
    public struct CountriesObj: Decodable { // or Decodable
        let name: String!
        let alpha2Code: String!
        let capital: String!
        var latlng: [Double]!
        let area: Float!
    }
    
    let countriesURL = "https://restcountries.eu/rest/v2/all?fields=name;capital;alpha2Code;area;latlng"
    var countriesDataArray = [CountriesObj]()

    public func config(callback: @escaping () -> (), callbackError: @escaping () -> ()) {
        if let url = URL(string: countriesURL) {
           URLSession.shared.dataTask(with: url) { data, response, error in
              if let data = data {
                 do {
                    let decoder = JSONDecoder()
                    let repos = try decoder.decode([CountriesObj].self, from: data)
                    
                    self.countriesDataArray = repos
                    callback()
                 } catch let error {
                    print("config error: \(error)")
                    callbackError()
                 }
               } else {
                print("config error: \(error!)")
                callbackError()
            }
           }.resume()
        }
    }
    
    public func getCountriesFromURL() -> [CountriesObj] {
        return countriesDataArray
    }
    
    public func getCapitalMapLocation(capital:String, country:String, locationCallback: @escaping (CLLocation) -> (), callbackError: @escaping () -> ()) {
        
        let capitalLocation = "\(capital), \(country)"
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(capitalLocation) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                print("couldn't find any location for \(capital): \(String(describing: error))")
                callbackError()
                return
            }
            locationCallback(location)
        }
    }
}
