//
//  LocalStorage.swift
//  ClimaCell
//
//  Created by Hadar Pur on 06/12/2019.
//  Copyright © 2019 Hadar Pur. All rights reserved.
//

import Foundation

class LocalStorage {
    struct defaultsKeys {
        static let countries = "Countries"
    }
    
    func saveCountries(countries: [CountriesData.CountriesObj]) {
        let defaults = UserDefaults.standard
        defaults.set(countries, forKey: defaultsKeys.countries)
        
        let myData = NSKeyedArchiver.archivedData(withRootObject: countries)
        defaults.set(myData, forKey: defaultsKeys.countries)
    }
    
    func getCountries() -> [CountriesData.CountriesObj] {
        let defaults = UserDefaults.standard
        var countries: [CountriesData.CountriesObj]?
        
        if let countriesArray = defaults.array(forKey: defaultsKeys.countries) {
            countries = countriesArray as? [CountriesData.CountriesObj]
        }

        return countries ?? []
    }
}
