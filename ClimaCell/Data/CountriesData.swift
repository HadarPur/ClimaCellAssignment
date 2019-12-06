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
        let area: Float!
    }
    
    let countriesURL = "https://restcountries.eu/rest/v2/all?fields=name;capital;alpha2Code;area"
    var countriesDataArray = [CountriesObj]()

    public func config(callback: @escaping () -> ()) {
        if let url = URL(string: countriesURL) {
           URLSession.shared.dataTask(with: url) { data, response, error in
              if let data = data {
                 do {
                    let decoder = JSONDecoder()
                    let repos = try decoder.decode([CountriesObj].self, from: data)
                    
                    self.countriesDataArray = repos
                    
                    callback()
                 } catch let error {
                    print(error)
                 }
               }
           }.resume()
        }
    }
    
    public func getCountriesFromURL() -> [CountriesObj] {
        return countriesDataArray
    }
    
    public func getCapitalMapLocation(capital:String, country:String, locationCallback: @escaping (CLLocation) -> ()) {
        
        let capitalLocation = "\(capital), \(country)"
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(capitalLocation) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                print("couldn't find any location: \(String(describing: error))")
                return
            }

            locationCallback(location)
        }
    }
}
