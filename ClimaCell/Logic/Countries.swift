//
//  CountriesData.swift
//  ClimaCell
//
//  Created by Hadar Pur on 06/12/2019.
//  Copyright © 2019 Hadar Pur. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

public class Countries {
    
    static let shared = Countries()
    let CData = CountriesData()
    
    func getCountries() -> [CountriesData.CountriesObj] {
        return CData.getCountriesFromURL()
    }

    //read the data from the firebase
    func readAllData(callback: @escaping () -> ()) {
        CData.config(callback: callback)
    }
    
    func getLocationForSpecificCapital(capitalObj: CountriesData.CountriesObj, callback: @escaping (CLLocation) -> ()) {
        CData.getCapitalMapLocation(capital: capitalObj.capital!, country: capitalObj.name!, locationCallback: callback)
    }
}
